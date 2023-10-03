class CreateTransferences < ActiveRecord::Migration[7.0]
  def change
    create_table :transferences do |t|
      t.float :value, null: false # the monetary value of the transference
      t.date :selected_date # An ISO date to schedule the transference,
                            # nil means that should be done immediately
      t.integer :hour # The scheduled hour,
                      # nil means that should be done immediately
      t.string :origin_account, null: false # sender account
      t.integer :status # 0 executed, 1 scheduled, 2 failed
      t.string :target_account_or_pix_key, null:false # target account or key
      t.integer :transference_type, null:false # transference type
                                               # PIX: 1, TED: 2, DOC: 3

      t.timestamps
    end
  end
end
