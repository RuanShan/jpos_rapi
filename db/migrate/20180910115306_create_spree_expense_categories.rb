class CreateSpreeExpenseCategories < ActiveRecord::Migration[5.1]
  def change
    #服务员/店铺一天的运营费用
    create_table "spree_expense_categories"  do |t|
      t.string "name"
      t.string "description"
      t.boolean "is_default", default: false
      t.datetime "deleted_at"
      t.timestamps null: false
      t.index ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at"
      t.index ["is_default"], name: "index_spree_tax_categories_on_is_default"
    end

    change_table "spree_expense_items" do |t|
      t.references 'expense_category'
    end

  end
end
