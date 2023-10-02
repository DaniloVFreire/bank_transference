require 'date';
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Transference.create!(value: 100.0, origin_account: '1234567890', target_account_Or_pix_key: '0987654321', type:1, created_at: Datetime.now, updated_at: Datetime.now)
Transference.create!(value: 150.0, origin_account: '0987654321', target_account_Or_pix_key: '1234567890',type:2 , created_at: Datetime.now, updated_at: Datetime.now)