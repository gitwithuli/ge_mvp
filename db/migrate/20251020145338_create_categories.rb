class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug
      # self-referential parent
      t.references :parent, foreign_key: { to_table: :categories }, index: true, null: true

      t.timestamps
    end

    add_index :categories, :slug, unique: false
  end
end