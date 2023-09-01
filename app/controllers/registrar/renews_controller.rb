module Registrar
  class RenewsController < ApplicationController
    include Roles::RegistrarAbilitable

    def show
      @domain = Domain.find_by_uuid(params[:uuid])
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def update
      @domain = Domain.find_by_uuid(params[:uuid])

      result = EstonianTld::RenewService.new(tld: Tld.first).transfer(
        payload: transfer_params, domain_name: @domain.name
      )

      if result.success
        @domain.renew(period_in_months: transfer_params[:period].to_i)
        redirect_to registrar_domains_path, notice: t('.success'), status: :see_other
      else
        Rails.logger.info "Error: #{result.body['message']}"
        flash.now[:alert] = "Error: #{result.body['message']}"

        render turbo_stream: turbo_stream.replace('flash', partial: 'layouts/flash')
      end
    end

    private

    def transfer_params
      params.require(:domain).permit(:name, :period, :expire_at)
    end
  end
end
