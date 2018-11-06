class AddNewCardCountSaleDay < ActiveRecord::Migration[5.1]
  def change
    #服务员/店铺一天的销售统计
    change_table "sale_days", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|

      #日service订单统计
      t.integer  "service_order_count", default: 0, null: false
      #日service order total money
      t.integer  "service_total", default: 0, null: false
      #card deposit include new
      t.integer  "deposit_total", default: 0, null: false



    end

    change_table "sale_months", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      #日service订单统计
      t.integer  "service_order_count", default: 0, null: false
      #日service order total money
      t.integer  "service_total", default: 0, null: false
      #card deposit include new
      t.integer  "deposit_total", default: 0, null: false
    end


  end
end
