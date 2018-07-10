class AddStorePrinterNames < ActiveRecord::Migration[5.1]
  def change

    # 对于未付款订单，客户取回物品时，需要付款，如果物品是多个，并且客户只取回了部分订单
    # 这时需要更新物品的 payment_state
    change_table(:spree_stores) do |t|
      t.column :doc_printer_name, :string
      t.column :receipt_printer_name, :string
      t.column :label_printer_name, :string
    end

  end
end
