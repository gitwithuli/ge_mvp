class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.references :listing, null: false, foreign_key: true
      t.integer :kind
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :price_cents
      t.string :provider
      t.string :provider_ref

      t.timestamps
    end
  end
end
