class AddHasFactoryIntoSites < ActiveRecord::Migration[5.2]
  def change
    # 客户是否需要工厂端功能
    add_column :spree_sites, :has_factory, :boolean,  null: false, default: false
  end

end
