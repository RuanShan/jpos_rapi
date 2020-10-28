class SupportMoreSites < ActiveRecord::Migration[5.2]
  def change
    # 服务分类，每个店有自己的服务分类
    add_column :spree_sites, :taxonomy_id, :integer,  null: false, default: 0
    
    add_column :spree_expense_categories, :site_id, :integer,  null: false, default: 0
  end

end
