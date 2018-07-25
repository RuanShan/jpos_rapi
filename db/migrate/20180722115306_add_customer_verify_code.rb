class AddCustomerVerifyCode < ActiveRecord::Migration[5.1]
  def change
    change_table(:customers) do |t|
      #会员 手机验证码
      t.column :verify_code, :string, limit: 12
    end

    change_table(:wx_followers) do |t|
      #微信号关联 - 会员号码时使用
      t.column :mobile, :string, limit: 24
      t.column :verify_code, :string, limit: 12
    end

  end
end
