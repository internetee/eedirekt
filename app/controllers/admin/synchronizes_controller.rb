module Admin
  class SynchronizesController < ApplicationController
    def create
      EstonianTld::ContactsJob.perform_now(Tld.first)
      redirect_to root_path, status: :see_other, notice: { success: t('.success') }
    end
  end
end