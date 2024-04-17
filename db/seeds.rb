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
       .first_or_create.update(code: 'vat', value: '22.0', format: 'float', group: 'invoice', description: 'VAT rate')  

# BILLING GROUP:

Setting.where(code: 'days_to_keep_invoices_active')
       .first_or_create.update(code: 'days_to_keep_invoices_active', value: '30', format: 'integer', group: 'billing', description: 'Number of days to keep invoices active')

# CONTACTS GROUP:

Setting.where(code: 'show_address_customer')
       .first_or_create.update(code: 'show_address_customer', value: 'false', format: 'boolean', group: 'contacts', description: 'Show and create address on customer page')

# Setting.where(code: 'code_of_technical_contact')
#        .first_or_create.update(code: 'code_of_technical_contact', value: nil, format: 'string', group: 'registrar', description: 'Code of technical contact')
Setting.where(code: 'code_of_technical_contact')
       .first_or_create.update(code: 'code_of_technical_contact', value: [], format: 'array', group: 'contacts', description: 'Code of technical contact')

# REGISTRAR GROUP:

json_value_1 = {
  hostname: 'ns1.example.com',
  ipv4: '127.0.0.1',
  ipv6: '0:0:0:0:0:0:0:1'
}

json_value_2 = {
  hostname: 'ns2.example.com',
  ipv4: '127.0.0.2',
  ipv6: '0:0:0:0:0:0:0:2'
}
Setting.where(code: 'default_nameserver_records')
       .first_or_create.update(
        code: 'default_nameserver_records', value: [json_value_1, json_value_2], 
        format: 'array', group: 'registrar', description: 'Default nameserver records')

dns_sec_default_value = {
  flags: '257',
  protocol: '3',
  algorithm: '13',
  public_key: 'mdsswUyr3DPW132mOi8V9xESWE8jTo0dxCjjnopKl+GqJxpVXckHAeF+KkxLbxILfDLUT0rAK9iUzy1L53eKGQ=='
}

Setting.where(code: 'dnssec_default_value')
        .first_or_create.update(code: 'dnssec_default_value', value: dns_sec_default_value.to_json, format: 'hash', group: 'registrar', description: 'Default DNSSEC value')

Setting.where(code: 'dnssec_enabled')
       .first_or_create.update(code: 'dnssec_enabled', value: 'false', format: 'boolean', group: 'registrar', description: 'Enable DNSSEC')

Setting.where(code: 'opt_in')
       .first_or_create.update(code: 'opt_in', value: 'false', format: 'boolean', group: 'registrar', description: 'Enable opt-in')

Setting.where(code: 'opt_out')
       .first_or_create.update(code: 'opt_out', value: 'false', format: 'boolean', group: 'registrar', description: 'Enable opt-out')

Setting.where(code: 'default_registration_and_renewal_period')
       .first_or_create.update(code: 'default_registration_and_renewal_period', value: '1y', format: 'integer', group: 'registrar', description: 'Default registration and renewal period')
