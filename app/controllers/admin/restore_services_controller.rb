module Admin
  class RestoreServicesController < ApplicationController
    include Roles::AdminAbilitable

    def create
      logout
      RestoreServiceToInitStateJob.perform_now

      redirect_to root_path, notice: t('.success')
    end
  end
end
