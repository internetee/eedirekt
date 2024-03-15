class DomainPrice < ApplicationRecord
  ZONES = ['ee'].freeze

  # enum operation_category: { create_domain: 0, renew_domain: 1 }
  enum operation_categories: [ :create_domain, :renew_domain ]

  # validates :price, :valid_from, :operation_category, :duration, presence: true
  # validates :operation_category, inclusion: { in: Proc.new { |price| price.class.operation_categories } }
  # validates :duration, inclusion: { in: Proc.new { |price| price.class.durations.values } },
  #                      if: :should_validate_duration?

  after_initialize do
    self.valid_from ||= Time.zone.now
  end

  # def self.operation_categories
  #   %w[create renew]
  # end

  def self.durations
    {
      '3 months' => 3.months,
      '6 months' => 6.months,
      '9 months' => 9.months,
      '1 year' => 1.year,
      '2 years' => 2.years,
      '3 years' => 3.years,
      '4 years' => 4.years,
      '5 years' => 5.years,
      '6 years' => 6.years,
      '7 years' => 7.years,
      '8 years' => 8.years,
      '9 years' => 9.years,
      '10 years' => 10.years,
    }
  end

  def months
    duration / 1.month
  end

  def years
    duration / 1.year
  end

  def self.statuses
    %w[upcoming effective expired]
  end
end
