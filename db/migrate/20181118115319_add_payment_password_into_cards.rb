class AddPaymentPasswordIntoCards < ActiveRecord::Migration[5.1]
  # 支持转卡功能， 即一张卡上的余额转到另外一张上
  def change
    change_table(:spree_cards) do |t|
      # 会员卡支付密码，明码保存
      t.string "payment_password", limit: 24   #会员卡状态 disabled, enabled, replaced
    end

  end
end
