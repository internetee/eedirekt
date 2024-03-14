module Admin
  class DomainPricesController < ApplicationController
    include Roles::AdminAbilitable

    def index
      @domain_prices = DomainPrice.all
    end

    def create
      @price = DomainPrice.new(price_params)
      
      if @price.save
        flash[:notice] = t('.created')
        redirect_to admin_domain_prices_path, status: :see_other
      else
        flash.now[:alert] = @price.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end

    def new
      @domain_price = DomainPrice.new
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private

    def price_params
      params.require(:domain_price).permit(:price, :valid_from, :valid_to, :duration, :operation_category, :zone)
    end
  end
end
