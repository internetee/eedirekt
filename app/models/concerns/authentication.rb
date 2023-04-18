module Authentication
  extend ActiveSupport::Concern

  def authenticate_session_token(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
