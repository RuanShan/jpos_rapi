class AddReturnedMemoIntoLineItemGroups < ActiveRecord::Migration[5.1]
  # 支持转卡功能， 即一张卡上的余额转到另外一张上
  def change
    change_table(:spree_line_item_groups) do |t|

      t.string "returned_memo", limit: 256   #返工返修备注
    end

  end
end
