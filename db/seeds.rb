# Setting.create(code: 'invoice_number_min', value: '999', format: 'integer', group: 'invoice', description: 'Minimum invoice number')
# Setting.create(code: 'invoice_number_max', value: '199999', format: 'integer', group: 'invoice', description: 'Maximum invoice number')
# Setting.create(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing', description: 'Number of days to keep invoices active')
# Setting.create(code: 'vat', value: '20.0', format: 'float', group: 'invoice', description: 'VAT rate')
# Setting.create(code: 'show_address_customer', value: 'false', format: 'boolean', group: 'contacts', description: 'Show and create address on customer page')

# INVOICE GROUP:

Setting.where(code: 'invoice_number_min')
       .first_or_create.update(code: 'invoice_number_min', value: '999', format: 'integer', group: 'invoice', description: 'Minimum invoice number')

Setting.where(code: 'invoice_number_max')
       .first_or_create.update(code: 'invoice_number_max', value: '199999', format: 'integer', group: 'invoice', description: 'Maximum invoice number')

Setting.where(code: 'vat')
       .first_or_create.update(code: 'vat', value: '20.0', format: 'float', group: 'invoice', description: 'VAT rate')  

# BILLING GROUP:

Setting.where(code: 'days_to_keep_invoices_active')
       .first_or_create.update(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing', description: 'Number of days to keep invoices active')

# CONTACTS GROUP:

Setting.where(code: 'show_address_customer')
       .first_or_create.update(code: 'show_address_customer', value: 'false', format: 'boolean', group: 'contacts', description: 'Show and create address on customer page')


# REGISTRAR GROUP:

Setting.where(code: 'default_nameserver_records')
       .first_or_create.update(code: 'default_nameserver_records', value: ['ns1.example.ee', 'ns2.example.ee'], format: 'array', group: 'registrar', description: 'Default nameserver records')

Setting.where(code: 'dnssec_enabled')
       .first_or_create.update(code: 'dnssec_enabled', value: 'false', format: 'boolean', group: 'registrar', description: 'Enable DNSSEC')

Setting.where(code: 'opt_in')
       .first_or_create.update(code: 'opt_in', value: 'false', format: 'boolean', group: 'registrar', description: 'Enable opt-in')

Setting.where(code: 'opt_out')
       .first_or_create.update(code: 'opt_out', value: 'false', format: 'boolean', group: 'registrar', description: 'Enable opt-out')

Setting.where(code: 'code_of_technical_contact')
       .first_or_create.update(code: 'code_of_technical_contact', value: nil, format: 'string', group: 'registrar', description: 'Code of technical contact')

Setting.where(code: 'default_registration_and_renewal_period')
       .first_or_create.update(code: 'default_registration_and_renewal_period', value: '1y', format: 'integer', group: 'registrar', description: 'Default registration and renewal period')
