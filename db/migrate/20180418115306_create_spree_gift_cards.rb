class CreateSpreeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_cards do |t|
      t.integer :variant_id, :null => false
      t.integer :line_item_id
      t.string :email, :null => false
      t.string :name
      t.text :note
      t.string :code, :null => false
      t.datetime :sent_at
      t.decimal :current_value, :precision => 8, :scale => 2, :null => false
      t.decimal :original_value, :precision => 8, :scale => 2, :null => false
      t.timestamps
    end
    create_table :spree_gift_card_transactions do |t|
      t.decimal :amount, scale: 2, precision: 6
      t.belongs_to :gift_card
      t.belongs_to :order
      t.timestamps
    end

    # 1 normal product, 2 充值卡, 3 次卡once card
    add_column :spree_products, :type_id, :integer, :default => 1, :null => false
  end
end
