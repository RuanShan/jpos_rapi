class AddLineItemCode < ActiveRecord::Migration[5.1]
  def change
    change_table(:spree_line_items) do |t|
      #客户输入的会员卡号
      t.column :card_code, :string, limit: 16
      t.date   :card_expire_at #卡片过期时间，客户端传入参数

    end
  end
end
