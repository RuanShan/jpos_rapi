class AddCardDeletedAt < ActiveRecord::Migration[5.1]
  def change
    change_table(:spree_cards) do |t|
      #会员号
      t.datetime "deleted_at"

    end

  end
end
