class AddProductLabelIcon < ActiveRecord::Migration[5.1]
  #打印标签时，需要打印（产品）工作对应的图标，
  def change
    change_table(:spree_line_items) do |t|
      t.string :label_icon_name, limit: 16  #wx.BMP
    end

    change_table(:spree_products) do |t|
      t.string :label_icon_name, limit: 16  #wx.BMP
    end
    
  end
end
