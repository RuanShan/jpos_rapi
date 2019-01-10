class AlterUserApiKeyNull < ActiveRecord::Migration[5.1]
  def change

    #ALTER TABLE `jpos_rapi_dev`.`users` CHANGE COLUMN `api_key` `api_key` VARCHAR(48) NULL DEFAULT NULL ;
    change_column(:users, :api_key, :string, limit: 48, default: nil, null: true)

  end
end
