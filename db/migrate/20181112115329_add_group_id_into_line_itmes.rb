class AddGroupIdIntoLineItmes < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_line_items) do |t|
      t.references  "group"
    end

  end
end
