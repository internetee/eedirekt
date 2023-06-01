# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Setting.create(code: 'invoice_number_min', value: '999', format: 'integer', group: 'invoice')
Setting.create(code: 'invoice_number_max', value: '199999', format: 'integer', group: 'invoice')
Setting.create(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing')
Setting.create(code: 'vat', value: '20.0', format: 'float', group: 'invoice')
