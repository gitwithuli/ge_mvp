class AddSearchVectorToListings < ActiveRecord::Migration[8.0]
  def up
    # ensure required extensions exist (safe if already enabled)
    enable_extension 'pg_trgm'     unless extension_enabled?('pg_trgm')
    enable_extension 'btree_gin'   unless extension_enabled?('btree_gin')

    # add column if missing (safe to re-run)
    unless column_exists?(:listings, :search_vector, :tsvector)
      add_column :listings, :search_vector, :tsvector
    end

    # GIN index for the tsvector
    unless index_exists?(:listings, :search_vector, using: :gin)
      add_index :listings, :search_vector, using: :gin
    end

    # Trigram index on title (requires pg_trgm)
    execute <<~SQL
      CREATE INDEX IF NOT EXISTS index_listings_on_title_trgm
      ON listings USING gin (title gin_trgm_ops);
    SQL

    # create or replace trigger function
    execute <<~SQL
      CREATE OR REPLACE FUNCTION listings_tsvector_update_trigger() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector :=
          to_tsvector('simple',
            coalesce(NEW.title, '') || ' ' || coalesce(NEW.description, ''));
        RETURN NEW;
      END
      $$ LANGUAGE plpgsql;
    SQL

    # attach trigger (drop first if exists, then create)
    execute <<~SQL
      DROP TRIGGER IF EXISTS tsvectorupdate ON listings;
      CREATE TRIGGER tsvectorupdate
      BEFORE INSERT OR UPDATE ON listings
      FOR EACH ROW
      EXECUTE FUNCTION listings_tsvector_update_trigger();
    SQL
  end

  def down
    # remove trigger and function
    execute "DROP TRIGGER IF EXISTS tsvectorupdate ON listings;"
    execute "DROP FUNCTION IF EXISTS listings_tsvector_update_trigger();"

    # drop trigram index on title
    execute "DROP INDEX IF EXISTS index_listings_on_title_trgm;"

    # drop GIN index and column if present
    remove_index :listings, :search_vector if index_exists?(:listings, :search_vector)
    remove_column :listings, :search_vector if column_exists?(:listings, :search_vector, :tsvector)
  end
end