class CreateConversations < ActiveRecord::Migration[7.2]
  def change
    create_table :conversations do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :buyer,   null: false, foreign_key: { to_table: :users }
      t.references :seller,  null: false, foreign_key: { to_table: :users }
      t.datetime :last_message_at
      t.timestamps
    end
    add_index :conversations, [:listing_id, :buyer_id], unique: true
  end
end
