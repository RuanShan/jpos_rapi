class CreateSpreeExpenseItems < ActiveRecord::Migration[5.1]
  def change
    #服务员/店铺一天的运营费用
    create_table "spree_expense_items"  do |t|
      t.references  "store"
      t.references  "user"
      t.references "variant"
      #日订单统计
      t.date     "day" #费用发生日期，
      t.date     "entry_day" #费用录入日期，
      t.string :cname  #费用名称
      t.decimal "price", precision: 10, scale: 2, null: false
      t.string :memo   #备注
      t.integer :state #费用状态  :正常，:取消
      t.timestamps null: false
    end


  end
end
