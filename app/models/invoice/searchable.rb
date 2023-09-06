module Invoice::Searchable
  extend ActiveSupport::Concern

  included do
    scope :by_number, ->(number) { where('invoices.number ILIKE ?', "%#{number}%") if number.present? }
    scope :by_status, ->(status) { where(status:) if status.present? }
    scope :by_reference_number, lambda { |reference_number|
                                  if reference_number.present?
                                    where('invoices.reference_number ILIKE ?', "%#{reference_number}%")
                                  end
                                }
    scope :by_buyer_name, ->(buyer_name) { where('contacts.name ILIKE ?', "%#{buyer_name}%") if buyer_name.present? }
    scope :by_buyer_ident, lambda { |buyer_ident|
                             where('contacts.ident ILIKE ?', "%#{buyer_ident}%") if buyer_ident.present?
                           }
    scope :with_issued_starts_at, lambda { |starts_at|
                                    if starts_at.present?
                                      where('invoices.issued_at >= ?', starts_at.to_date.beginning_of_day)
                                    end
                                  }
    scope :with_issued_ends_at, lambda { |ends_at|
                                  where('invoices.issued_at <= ?', ends_at.to_date.end_of_day) if ends_at.present?
                                }
  end

  # rubocop:disable Metrics
  class_methods do
    def search_filter(params = {})
      sort_column = params[:sort] || 'created_at'
      sort_direction = params[:direction] || 'desc'

      by_number(params[:number])
        .by_status(params[:invoice_status])
        .by_reference_number(params[:reference_number])
        .by_buyer_name(params[:buyer_name])
        .by_buyer_ident(params[:buyer_ident])
        .with_issued_starts_at(params[:issued_start_date])
        .with_issued_ends_at(params[:issued_end_date])
        .order("#{sort_column} #{sort_direction}")
    end
  end
end
