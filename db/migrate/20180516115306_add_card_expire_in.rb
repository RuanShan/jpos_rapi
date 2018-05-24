class AddCardExpireIn < ActiveRecord::Migration[5.1]
  def change
    #会员卡的过期时间
    #card_expire_in 天数，这样可以指定任意时间
    add_column :spree_variants, :card_expire_in, :integer, default: 0
    add_column :spree_variants, :card_discount_percent, :integer, default: 0
    add_column :spree_variants, :card_discount_amount, :integer, default: 0

  end
end
