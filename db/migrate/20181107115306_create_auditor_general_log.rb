class CreateAuditorGeneralLog < ActiveRecord::Migration[5.1]
  def change
    # ALTER TABLE auditor_general_logs CHANGE alterations alterations TEXT CHARACTER SET utf8 COLLATE utf8_general_ci;
    create_table :auditor_general_logs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|

      t.string :model_type
      t.integer :model_id
      t.string :action
      t.text :alterations
      t.text :message
      t.integer :origin_id, index: true
      #t.string :origin, index: true
      t.timestamps null: false
    end

    add_index(:auditor_general_logs, [:model_type, :model_id])
  end
end
