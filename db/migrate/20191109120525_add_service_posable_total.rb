class AddServicePosableTotal < ActiveRecord::Migration[5.2]
  def change
    # 客户支付现金汇总，用于今天收入统计
    add_column :sale_days, :service_posable_total, :integer,  null: false, default: 0
  end

end
