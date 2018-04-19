class CreateSpreeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_cards do |t|
      t.references(:user)
      t.string :code, :null => false
      t.integer :variant_id, :null => false
      t.integer :line_item_id
      t.string :email, :null => false
      t.string :name
      t.text :note
      t.datetime :sent_at
      t.decimal  :discount # percent
      t.decimal :current_value, :precision => 8, :scale => 2, :null => false
      t.decimal :original_value, :precision => 8, :scale => 2, :null => false
      t.timestamps
    end
    create_table :spree_card_transactions do |t|
      t.decimal :amount, scale: 2, precision: 6
      t.belongs_to :card
      t.belongs_to :order
      t.belongs_to :line_item
      t.timestamps
    end

    # 1 normal product, 2 充值卡, 3 次卡once card
    add_column :spree_products, :type_id, :integer, :default => 1, :null => false
    add_column :spree_products, :type, :string, limit: 24
  end
end
