class AddCardExpireIn < ActiveRecord::Migration[5.1]
  def change

    add_column :spree_variants, :card_expire_in, :integer, default: 0 #客户会员卡过期时间 enum  1天，1月，1年，
    add_column :spree_variants, :card_discount_percent, :integer, default: 0
    add_column :spree_variants, :card_discount_amount, :integer, default: 0

  end
end
