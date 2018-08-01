class AddLineItemCode < ActiveRecord::Migration[5.1]
  def change
    change_table(:spree_line_items) do |t|
      #客户输入的会员卡号
      t.column :code, :string, limit: 16

    end
  end
end
