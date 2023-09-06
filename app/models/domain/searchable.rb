module Domain::Searchable
  extend ActiveSupport::Concern

  included do
    scope :by_domain_name, ->(name) { where('domains.name ILIKE ?', "%#{name}%") }
    scope :by_email, lambda { |email|
                       joins(:contacts).where('contacts.email ILIKE ?', "%#{email}%") if email.present?
                     }
    scope :by_registrant_name, lambda { |name|
                                 joins(:registrant).where('contacts.name ILIKE ?', "%#{name}%") if name.present?
                               }
    scope :by_contact_name, ->(name) { joins(:contacts).where('contacts.name ILIKE ?', "%#{name}%") if name.present? }
    scope :by_nameserver_name, lambda { |name|
                                 joins(:nameservers).where('nameservers.hostname ILIKE ?', "%#{name}%") if name.present?
                               }

    scope :with_starts_at, (lambda do |starts_at|
      where('domains.created_at >= ?', starts_at.to_date.beginning_of_day) if starts_at.present?
    end)
    scope :with_ends_at, (lambda do |ends_at|
      where('domains.created_at <= ?', ends_at.to_date.end_of_day) if ends_at.present?
    end)

    scope :by_domain_status, ->(status) { where('domains.statuses @> ?', "{#{status}}") if status.present? }
  end

  # rubocop:disable Metrics
  class_methods do
    def search(params = {})
      sort_column = params[:sort] || 'created_at'
      sort_direction = params[:direction] || 'desc'

      by_domain_name(params[:domain_name])
        .by_email(params[:email])
        .by_registrant_name(params[:registrant_name])
        .by_contact_name(params[:contact_name])
        .by_nameserver_name(params[:nameserver_name])
        # .by_date_range(params[:start_date], params[:end_date])
        .with_starts_at(params[:start_date])
        .with_ends_at(params[:end_date])
        .by_domain_status(params[:domain_status])
        .order("#{sort_column} #{sort_direction}")
    end
  end
end
