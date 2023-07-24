module Admin
  class RegistrarUsersController < ApplicationController
    include Roles::AdminAbilitable

    before_action :set_registrar_user, except: [:index, :new, :create]

    def index
      @registrar_users = RegistrarUser.all
    end

    def show; end

    def new
      @registrar_user = RegistrarUser.new
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def create
      @registrar_user = RegistrarUser.new(registrar_user_params)

      if @registrar_user.save
        redirect_to admin_registrar_users_path, status: :see_other, notice: { success: I18n.t('.success') }
      else

        render :new, status: :unprocessable_entity,
                     notice: { alert: @registrar_user&.errors&.full_messages&.join('; ') }
      end
    end

    def edit; end

    def update
      if @registrar_user.update(registrar_user_params)
        redirect_to admin_registrar_users_path, status: :see_other, notice: { success: I18n.t('.success') }
      else
        render 'registrar_users/edit', status: :unprocessable_entity,
                                       notice: { alert: @registrar_user.errors.full_messages.join('; ') }
      end
    end

    def destroy
      if @registrar_user.destroy
        redirect_to admin_registrar_users_path, status: :see_other, notice: { success: I18n.t('.success') }
      else
        render 'registrar_users/index', status: :unprocessable_entity,
                                        notice: { alert: @registrar_user.errors.full_messages.join('; ') }
      end
    end

    private

    def set_registrar_user
      @registrar_user = RegistrarUser.find_by_uuid(params[:uuid])
    end

    def registrar_user_params
      params.require(:registrar_user).permit(RegistrarUser.permitted_attributes)
    end
  end
end
