class AddCustomerNumber < ActiveRecord::Migration[5.1]
  def change
    change_table(:customers) do |t|
      #会员号
      t.column :number, :string, limit: 64, null: false, default: ''
    end

  end
end
