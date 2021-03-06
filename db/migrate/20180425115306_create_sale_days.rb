class CreateSaleDays < ActiveRecord::Migration[5.1]
  def change
    #服务员/店铺一天的销售统计
    create_table "sale_days", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.references  "store"
      t.string   "seller_type"
      t.integer  "user_id"

      t.date     "day" #统计有效日期
      #日订单统计
      t.integer  "new_orders_count", default: 0, null: false
      #新客户
      t.integer  "new_customers_count", default: 0, null: false
      #新购卡
      t.integer  "new_cards_count", default: 0, null: false

      #works for each day
      t.integer  "processed_line_items_count", default: 0, null: false

      t.timestamps null: false
      t.index ["seller_type", "user_id", "day"]
    end

    create_table "sale_months", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "seller_type"
      t.integer  "user_id"
      t.date     "day" #统计有效日期
      #月订单统计
      t.integer  "new_order_count",           default: 0, null: false
      #新客户
      t.integer  "new_customer_count",  default: 0, null: false
      #新购卡
      t.integer  "new_card_count", default: 0, null: false

      t.integer  "processed_line_items_count", default: 0, null: false

      t.timestamps null: false
      t.index ["seller_type", "user_id", "day"]
    end


    add_column :spree_line_items, :work_at, :datetime

  end
end
