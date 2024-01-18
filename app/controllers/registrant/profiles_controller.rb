module Registrant
  class ProfilesController < ApplicationController
    include Roles::RegistrantAbilitable

    def edit; end

    def update
      if current_user.update!(user_params)
        EstonianTld::CreateContactJob.perform_now(current_user)
        redirect_to edit_registrant_profiles_path, notice: t('.success')
      else
        flash.now[:alert] = current_user.errors.full_messages.join(', ')
        render :edit
      end
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :phone, :phone_code, :ident, :role, :country_code,
        :city, :street, :zip, :state, :legal_document, :code
      )
    end
  end
end
