class CreateTransferences < ActiveRecord::Migration[7.0]
  def change
    create_table :transferences do |t|
      t.float :value, null: false
      t.date :selected_date
      t.integer :hour
      t.string :origin_account, null: false
      t.integer :status
      t.string :target_account_Or_pix_key, null:false
      t.integer :transference_type, null:false

      t.timestamps
    end
  end
end
