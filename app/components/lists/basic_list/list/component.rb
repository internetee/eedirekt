module Lists
  module BasicList
    module List
      class Component < ApplicationViewComponent
        attr_reader :item, :item_url

        def initialize(item:, item_url:)
          super

          @item = item
          @item_url = item_url
        end

        def build_link
          tag.a "#{item.name} #{object_code}", href: item_url, class: 'truncate text-sm font-medium text-indigo-600'
        end

        def status
          case item.class.name.underscore
          when 'contact'
            tag.p 'Valid', class: 'inline-flex rounded-full bg-green-100 px-2 text-xs font-semibold leading-5 text-green-800'
          when 'domain'
            tag.p 'Active', class: 'inline-flex rounded-full bg-green-100 px-2 text-xs font-semibold leading-5 text-green-800'
          end
        end

        def leading
          case item.class.name.underscore
          when 'contact'
            item.domain_contacts.select { |dc| dc.domain.uuid == params[:uuid] }.pluck(:type).join(', ')
          when 'domain'
            "Transfer code #{item.information['transfer_code']}"
          end
        end

        # rubocop:disable Metrics/AbcSize
        def trailing
          case item.class.name.underscore
          when 'contact'
            ('Updated at ' + tag.time(item.updated_at, datetime: item.updated_at)).html_safe
          when 'domain'
            ('Expire at ' + tag.time(item.expire_at, datetime: item.expire_at)).html_safe
          end
        end

        def object_code
          case item.class.name.underscore
          when 'contact'
            "#{(item&.code).to_s.upcase}"
          when 'domain'
            roles = item.domain_contacts.select { |dc| dc.contact.uuid == params[:uuid] }.pluck(:type).join(', ')

            "[#{roles}]"
          end
        end
      end
    end
  end
end
