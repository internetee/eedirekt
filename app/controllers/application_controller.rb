class ApplicationController < ActionController::Base
  before_action :redirect_to_welcome_page

  rescue_from ActionController::Redirecting::UnsafeRedirectError do
    redirect_to root_url, layout: false
  end

  include Pagy::Backend
  include Authenticate

  private

  def redirect_to_welcome_page
    redirect_to settings_introduces_path, status: :see_other if SuperUser.count.zero?
  end
end
