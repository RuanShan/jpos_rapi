class CreateUserEntries < ActiveRecord::Migration[5.1]
  def change
    #服务员/店铺一天的打卡记录
    create_table "user_entries"  do |t|
      t.references  "store"
      t.references  "user"

      #日订单统计
      t.integer :state #打卡状态  :checkin, :checkout
      t.timestamps null: false
    end


  end
end
