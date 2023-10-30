module Contact::Searchable
  extend ActiveSupport::Concern

  included do
    scope :by_name, ->(name) { where('contacts.name ILIKE ?', "%#{name}%") if name.present? }
    scope :by_code, ->(code) { where('contacts.code ILIKE ?', "%#{code}%") if code.present? }
    scope :by_ident, ->(ident) { where('contacts.ident ILIKE ?', "%#{ident}%") if ident.present? }
    scope :by_ident_type, ->(ident_type) { where(role: ident_type) if ident_type.present? }
    scope :by_ident_state, ->(state) { where(state:) if state.present? }
    scope :by_ident_country, lambda { |ident_country|
                               where('contacts.country_code ILIKE ?', "%#{ident_country}%") if ident_country.present?
                             }
    scope :by_email, ->(email) { where('contacts.email ILIKE ?', "%#{email}%") if email.present? }
    scope :with_updated_starts_at, lambda { |starts_at|
                                     if starts_at.present?
                                       where('contacts.updated_at >= ?', starts_at.to_date.beginning_of_day)
                                     end
                                   }
    scope :with_updated_ends_at, lambda { |ends_at|
                                   where('contacts.updated_at <= ?', ends_at.to_date.end_of_day) if ends_at.present?
                                 }
    scope :with_created_starts_at, lambda { |starts_at|
                                     if starts_at.present?
                                       where('contacts.created_at >= ?', starts_at.to_date.beginning_of_day)
                                     end
                                   }
    scope :with_created_ends_at, lambda { |ends_at|
                                   where('contacts.created_at <= ?', ends_at.to_date.end_of_day) if ends_at.present?
                                 }
    scope :by_status, lambda { |status|
      return unless status.present?

      if status.include? 'not_linked'
        return where.not("information -> 'statuses' ->> ? IS NOT NULL", 'linked').where("information -> 'statuses' ->> ? IS NULL", status)
      end

      where("information -> 'statuses' ->> ? IS NOT NULL", status)
    }
  end

  # rubocop:disable Metrics
  class_methods do
    def search_filter(params = {})
      sort_column = params[:sort] || 'created_at'
      sort_direction = params[:direction] || 'desc'

      by_name(params[:name])
        .by_code(params[:code])
        .by_ident(params[:ident])
        .by_ident_type(params[:ident_type])
        .by_ident_state(params[:state])
        .by_ident_country(params[:ident_country])
        .by_email(params[:email])
        .with_updated_starts_at(params[:updated_start_date])
        .with_updated_ends_at(params[:updated_end_date])
        .with_created_starts_at(params[:created_start_date])
        .with_created_ends_at(params[:created_end_date])
        .by_status(params[:contact_status])
        .order("#{sort_column} #{sort_direction}")
    end
  end
end
