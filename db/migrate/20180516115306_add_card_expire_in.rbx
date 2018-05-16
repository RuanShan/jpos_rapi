class AddCardExpireIn < ActiveRecord::Migration[5.1]
  def change

    add_column :variants, :card_expire_in, :integer #客户会员卡过期时间 enum  1天，1月，1年，

  end
end
