module Registrar
  class PollMessagesController < ApplicationController
    include Roles::RegistrarAbilitable

    def update
      notification_id = params[:id]
      result = EstonianTld::PollMessageService.new(tld:).mark_as_read(notification_id)

      if result.success
        redirect_to root_path_path, notice: t('.success'), status: :see_other
      else
        flash[:alert] = t('.failure')
        render 'dashboards/index', status: :unprocessable_entity
      end
    end

    private

    def tld
      @tld ||= Tld.first
    end
  end
end
