class AddCardMoney < ActiveRecord::Migration[5.2]
  def change
    # 客户支付多钱    
    add_column :spree_cards, :money, :integer,  null: false, default: 0
    # remove_column :spree_variants, :lock_version
  end

end
