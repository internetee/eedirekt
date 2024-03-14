module Sidebar
  module Navbar
    class Component < ApplicationViewComponent
      def initialize(current_user:)
        super

        @current_user = current_user
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def menu_items
        if @current_user&.class&.name == 'SuperUser'
          [
            {
              href: root_path,
              name: I18n.t('dashboard'),
              heroicon_name: 'home'
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
            },
            {
              href: admin_domain_prices_path,
              name: I18n.t('domain_prices'),
              heroicon_name: 'cog'
            }
          ]
        elsif @current_user&.class&.name == 'RegistrarUser'
          [
            {
              href: root_path,
              name: I18n.t('dashboard'),
              heroicon_name: 'home'
            },
            {
              href: registrar_domains_path,
              name: I18n.t('domains'),
              heroicon_name: 'globe-europe-africa'
            },
            {
              href: registrar_contacts_path,
              name: I18n.t('contact'),
              heroicon_name: 'user'
            },
            {
              href: registrar_invoices_path,
              name: I18n.t('invoices'),
              heroicon_name: 'banknotes'
            },
            {
              href: registrar_poll_messages_path,
              name: I18n.t('poll_messages'),
              heroicon_name: 'envelope-open'
            },
            {
              href: registrar_settings_path,
              name: I18n.t('settings_item'),
              heroicon_name: 'cog'
            }
          ]
        else
          [
            {
              href: registrant_domains_path,
              name: I18n.t('domains'),
              heroicon_name: 'globe-europe-africa'
            },
            {
              href: edit_registrant_profiles_path,
              name: I18n.t('profile'),
              heroicon_name: 'user'
            }
        ]
        end
      end
    end
  end
end
