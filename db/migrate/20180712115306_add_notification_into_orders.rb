class AddNotificationIntoOrders < ActiveRecord::Migration[5.1]
  def change
    # 打印选项，打印小票，打印水洗唛， 通知选项：短信通知，公众号电子小票通知
    change_table(:spree_orders) do |t|
      t.column :enable_sms, :boolean, null: false, default: false
      t.column :enable_mp_msg, :boolean, null: false, default: false
    end

    change_table(:spree_payments) do |t|
      t.column :cname, :string # custom payment_method.name

    end
  end
end
