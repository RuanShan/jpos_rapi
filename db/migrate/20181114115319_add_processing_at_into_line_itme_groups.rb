class AddProcessingAtIntoLineItmeGroups < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_line_item_groups) do |t|
      t.datetime :processing_at  # time to factory
      t.datetime :processed_at   # time to done
      t.datetime :state_at   # time to state changed
    end

  end
end
