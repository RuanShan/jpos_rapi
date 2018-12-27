class CreateSmsTemplates < ActiveRecord::Migration[5.1]
  def change

    change_table "spree_sites"  do |t|
      t.text :sms_templates
    end


  end
end
