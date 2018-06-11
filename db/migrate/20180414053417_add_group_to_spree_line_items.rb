class AddGroupToSpreeLineItems < ActiveRecord::Migration[5.1]
  def change
    # 订单生成，一个鞋子可能有两项服务，修鞋和洗鞋，即生成两条子订单，子订单是和服务项目相对应的。
    # 同时生成条形码时，应为1个。即条形码是和服务物品相对应的。
    add_column :spree_line_items, :group_number, :string, limit: 24
    #   0000000000   0000
    #   [datetime]   [rand(num)]  num: 4 byte random number
    # 在客户端，店员设置 group_position，实现一个鞋子两个服务，同一个物品，设置相同的group_position
    # 后台根据group_position生产相应的group_number
    add_column :spree_line_items, :group_position, :integer, :default => 0, :null => false
    add_column :spree_line_items, :state, :string, limit: 24

    # 订单生成，一个鞋子可能有两项服务，修鞋和洗鞋，即生成两条子订单，子订单是和服务项目相对应的。
    # create line item group,
    # each line_item is service, each group is a customer shose,一个鞋子可能有两项服务
    create_table "spree_line_item_groups", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer :store_id #统计不同门店的数据量
      #t.integer :customer_id #以便直接查找 这个物品的客户信息
      t.string "name"
      t.string "number" #物品条码
      t.decimal "price", precision: 10, scale: 2, default: "0.0"
      t.datetime "shipped_at"
      t.string "state"
      t.integer "order_id"
      t.timestamps null: false
    end
    add_column :spree_orders, :group_state, :string, limit: 24

  end
end
