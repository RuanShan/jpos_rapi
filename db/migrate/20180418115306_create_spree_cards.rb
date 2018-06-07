class CreateSpreeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_cards do |t|
      t.references(:user) #卡的所有者
      t.integer :created_by_id #这个打折卡的创建者是谁
      t.string :code, :null => false
      # 1：充值卡， 2：次卡
      t.integer :style, :default => 0, :null => false
      t.integer :variant_id, :null => false
      t.integer :line_item_id
      t.string :name
      t.text :note
      t.datetime :sent_at
      t.datetime :expire_at #卡的到期时间
      t.integer  :discount_percent # percent
      t.integer  :discount_amount # percent
      t.decimal :current_value, :precision => 8, :scale => 2, :null => false
      t.decimal :original_value, :precision => 8, :scale => 2, :null => false
      t.integer :status, :default => 0, :null => false #卡的状态，是否可用, 1:可用， 0：不可用
      t.timestamps
    end
    #spree_payment 保存商品支付记录，
    #用户购买打折卡，充值打折卡或使用打折卡支付，会导致卡的余额变化，
    #spree_card_transactions，用户记录每一笔余额变化，可能有正也有负
    create_table :spree_card_transactions do |t|
      t.decimal :amount, scale: 2, precision: 6
      t.belongs_to :card
      t.belongs_to :order
      t.belongs_to :line_item
      t.datetime :completed_at
      t.timestamps
    end

    # 0 充值卡, 1 次卡once card
    add_column :spree_products, :card_style, :integer, :default => 0, :null => false
    add_column :spree_products, :type, :string, limit: 24
    # line_item has many card
    add_column :spree_line_items, :card_id, :integer, :default => 0, :null => false
    add_column :spree_line_items, :worker_id, :integer, :default => 0, :null => false
  end
end
