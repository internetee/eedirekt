# Setting.create(code: 'invoice_number_min', value: '999', format: 'integer', group: 'invoice', description: 'Minimum invoice number')
# Setting.create(code: 'invoice_number_max', value: '199999', format: 'integer', group: 'invoice', description: 'Maximum invoice number')
# Setting.create(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing', description: 'Number of days to keep invoices active')
# Setting.create(code: 'vat', value: '20.0', format: 'float', group: 'invoice', description: 'VAT rate')
# Setting.create(code: 'show_address_customer', value: 'false', format: 'boolean', group: 'contacts', description: 'Show and create address on customer page')

Setting.where(code: 'invoice_number_min')
       .first_or_create.update(code: 'invoice_number_min', value: '999', format: 'integer', group: 'invoice', description: 'Minimum invoice number')

Setting.where(code: 'invoice_number_max')
       .first_or_create.update(code: 'invoice_number_max', value: '199999', format: 'integer', group: 'invoice', description: 'Maximum invoice number')

Setting.where(code: 'days_to_keep_invoices_active')
       .first_or_create.update(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing', description: 'Number of days to keep invoices active')

Setting.where(code: 'vat')
       .first_or_create.update(code: 'vat', value: '20.0', format: 'float', group: 'invoice', description: 'VAT rate')

Setting.where(code: 'show_address_customer')
       .first_or_create.update(code: 'show_address_customer', value: 'false', format: 'boolean', group: 'contacts', description: 'Show and create address on customer page')
