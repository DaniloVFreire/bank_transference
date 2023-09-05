class CreateTransferences < ActiveRecord::Migration[7.0]
  def change
    create_table :transferences do |t|
      t.float :value
      t.date :selected_date
      t.integer :hour
      t.string :origin_account
      t.integer :status
      t.string :target_account
      t.integer :type
      t.string :target_pix_key

      t.timestamps
    end
  end
end
