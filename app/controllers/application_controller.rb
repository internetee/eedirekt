class ApplicationController < ActionController::Base
  before_action :redirect_to_welcome_page
  before_action :tld

  rescue_from ActionController::Redirecting::UnsafeRedirectError do
    redirect_to root_url, layout: false
  end

  include Pagy::Backend
  include Authenticate

  def tld
    @tld ||= Tld.first
  end

  def current_api_adapter
    EstonianReppAdapter.new
  end

  private

  def redirect_to_welcome_page
    redirect_to settings_introduces_path, status: :see_other if SuperUser.count.zero?
  end
end
