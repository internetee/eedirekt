class SessionsController < ApplicationController
  include ApplicationHelper

  layout 'sessions'

  allow_unauthenticated only: %i[new]

  def new
    redirect_to root_path if logged_in?
  end

  def destroy
    flash[:success] = t('.success')

    if admin?
      logout && redirect_to(new_sessions_path, status: :see_other)
    elsif registrar?
      logout && redirect_to(new_registrar_sessions_path, status: :see_other)
    else
      logout && redirect_to(new_sessions_path, status: :see_other)
    end
  end
end
