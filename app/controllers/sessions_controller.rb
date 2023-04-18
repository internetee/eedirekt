class SessionsController < ApplicationController
  allow_unauthenticated only: %i[new]

  def new
    redirect_to root_path if logged_in?
  end

  def destroy
    logout

    flash[:success] = t('.success')
    redirect_to new_sessions_path, status: :see_other
  end
end
