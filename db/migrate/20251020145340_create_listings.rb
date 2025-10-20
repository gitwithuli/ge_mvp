class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :price_cents
      t.string :currency
      t.integer :status
      t.integer :condition
      t.integer :views_count
      t.integer :favorites_count
      t.integer :messages_count
      t.datetime :promoted_until
      t.string :slug

      t.timestamps
    end
  end
end
