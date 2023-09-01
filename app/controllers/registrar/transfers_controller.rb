module Registrar
  class TransfersController < ApplicationController
    include Roles::RegistrarAbilitable

    def show; end

    def update
      result = EstonianTld::TransferService.new(tld: Tld.first).transfer(payload: transfer_params)

      if result.success
        redirect_to registrar_domains_path, notice: t('.success'), status: :see_other
      else
        Rails.logger.info "Error: #{result.body['message']}"
        render :show, alert: "Error: #{result.body['message']}", status: :unprocessable_entity
      end
    end

    def transfer_params
      params.require(:domain).permit(:domain_name, :transfer_code)
    end
  end
end
