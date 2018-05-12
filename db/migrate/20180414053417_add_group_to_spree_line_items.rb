class AddGroupToSpreeLineItems < ActiveRecord::Migration[5.1]
  def change
    # 订单生成，一个鞋子可能有两项服务，修鞋和洗鞋，即生成两条子订单，子订单是和服务项目相对应的。
    # 同时生成条形码时，应为1个。即条形码是和服务物品相对应的。
    add_column :spree_line_items, :group_number, :string, limit: 24
    #   0000000000   0000
    #   [datetime]   [rand(num)]  num: 4 byte random number
    add_column :spree_line_items, :group_position, :integer
    add_column :spree_line_items, :state, :string, limit: 24

    # 订单生成，一个鞋子可能有两项服务，修鞋和洗鞋，即生成两条子订单，子订单是和服务项目相对应的。
    # create line item group,
    # each line_item is service, each group is a customer shose,一个鞋子可能有两项服务
    create_table "spree_line_item_groups", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.string "number" #物品条码
      t.decimal "cost", precision: 10, scale: 2, default: "0.0"
      t.datetime "shipped_at"
      t.string "state"
      t.integer "order_id"
      t.timestamps null: false
    end
    add_column :spree_orders, :group_state, :string, limit: 24

  end
end
