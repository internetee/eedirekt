module Domain::Renew
  extend ActiveSupport::Concern

  def renew(period_in_months:)
    time = calculate_expiry(period_in_months)
    self.expire_at = time

    save!
  end

  def calculate_expiry(period)
    (Time.zone.now.advance(months: period) + 1.day).beginning_of_day
  end
end
