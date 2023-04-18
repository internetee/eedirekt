class AppSession < ApplicationRecord
  belongs_to :sessionable, polymorphic: true

  has_secure_password :token, validations: false

  before_create do
    self.token = self.class.generate_unique_secure_token
  end

  def to_h
    {
      sessionable_type:,
      sessionable_id:,
      app_session: id,
      token:
    }
  end
end
