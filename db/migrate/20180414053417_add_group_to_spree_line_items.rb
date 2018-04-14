class AddGroupToSpreeLineItems < ActiveRecord::Migration[5.1]
  def change
    # 订单生成，一个鞋子可能有两项服务，修鞋和洗鞋，即生成两条子订单，子订单是和服务项目相对应的。
    # 同时生成条形码时，应为1个。即条形码是和服务物品相对应的。
    add_column :spree_line_items, :group_number, :string, limit: 24
    #   0000000000   0000
    #   [datetime]   [rand(num)]  num: 4 byte random number
    add_column :spree_line_items, :group_position, :integer
    add_column :spree_shipments, :group_number, :string, limit: 24

  end
end
