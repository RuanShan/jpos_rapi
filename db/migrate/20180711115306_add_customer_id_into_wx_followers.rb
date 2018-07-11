class AddCustomerIdIntoWxFollowers < ActiveRecord::Migration[5.1]
  def change

    change_table(:wx_followers) do |t|
      t.column :customer_id, :integer
    end

  end
end
