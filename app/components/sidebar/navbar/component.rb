module Sidebar
  module Navbar
    class Component < ApplicationViewComponent
      def initialize(current_user:)
        @current_user = current_user
      end

      def menu_items
        if @current_user&.class&.name == 'SuperUser'
          [
            {
              href: root_path,
              name: I18n.t('dashboard'),
              heroicon_name: 'home' ,
            },
            {
              href: admin_registrar_users_path,
              name: I18n.t('registrars'),
              heroicon_name: 'user-group'
            },
            {
              href: admin_settings_path,
              name: I18n.t('settings_item'),
              heroicon_name: 'cog'
            }
          ]
        elsif @current_user&.class&.name == 'RegistrarUser'
          [
            {
              href: root_path,
              name: I18n.t('dashboard'),
              heroicon_name: 'home' ,
            },
            {
              href: registrar_contacts_path,
              name: I18n.t('contacts'),
              heroicon_name: 'user' ,
            },
            {
              href: registrar_domains_path,
              name: I18n.t('domains'),
              heroicon_name: 'globe-europe-africa' ,
            },
            {
              href: registrar_invoices_path,
              name: I18n.t('invoices'),
              heroicon_name: 'banknotes' ,
            },
          ]
        else
          []
        end
      end
    end
  end
end
