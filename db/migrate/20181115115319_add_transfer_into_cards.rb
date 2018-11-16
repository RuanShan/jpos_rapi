class AddTransferIntoCards < ActiveRecord::Migration[5.1]
  # 支持转卡功能， 即一张卡上的余额转到另外一张上
  def change
    change_table(:spree_cards) do |t|
      t.references  "replaced_with" #新的替换卡id
      t.datetime  "replaced_at"     #替换时间
      #为了便于状态审计，使用state_machine, status不在使用
      t.string "state", limit: 24   #会员卡状态 disabled, enabled, replaced
    end

  end
end
