class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string  :name, null: false
      t.integer :kind, null: false, default: 0
      t.string  :slug
      # self-referential parent
      t.references :parent, foreign_key: { to_table: :locations }, index: true, null: true

      t.timestamps
    end

    add_index :locations, :slug, unique: false
  end
end