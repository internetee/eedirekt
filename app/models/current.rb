class Current < ActiveSupport::CurrentAttributes
  attribute :user, :app_session
end
