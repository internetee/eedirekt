module HasSession
  extend ActiveSupport::Concern

  included do
    has_many :app_sessions, as: :sessionable, dependent: :destroy
  end
end
