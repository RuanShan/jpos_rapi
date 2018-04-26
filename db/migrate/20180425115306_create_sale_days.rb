class CreateSaleDays < ActiveRecord::Migration[5.1]
  def change
    #服务员/店铺一天的销售统计
    create_table "sale_days", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "seller_type"
      t.integer  "seller_id"

      t.date     "effective_on" #统计有效日期
      #日订单统计
      t.integer  "order_count",           default: 0, null: false
      #新客户
      t.integer  "new_customer_count",  default: 0, null: false
      #新购卡
      t.integer  "new_card_count", default: 0, null: false
      t.timestamps null: false
      t.index ["seller_type", "seller_id", "effective_on"]
    end

    create_table "sale_months", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "seller_type"
      t.integer  "seller_id"
      t.date     "effective_on" #统计有效日期
      #月订单统计
      t.integer  "order_count",           default: 0, null: false
      #新客户
      t.integer  "new_customer_count",  default: 0, null: false
      #新购卡
      t.integer  "new_card_count", default: 0, null: false
      t.timestamps null: false
      t.index ["seller_type", "seller_id", "effective_on"]
    end


    add_column :users, :created_by_id, :integer #这个客户的创建者是谁
    add_column :spree_cards, :created_by_id, :integer #这个打折卡的创建者是谁

  end
end
