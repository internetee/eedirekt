module Registrant
  class PendingActionsController < ApplicationController
    include Roles::RegistrantAbilitable

    def show
      @pending_action = current_user.pending_actions.find_by(uuid: params[:uuid])
    end
  end
end
