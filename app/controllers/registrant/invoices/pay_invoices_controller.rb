module Registrant
  module Invoices
    class PayInvoicesController < ApplicationController
      include Roles::RegistrantAbilitable

      def create
        # invoice = Invoice.accessible_by(current_ability).find_by!(uuid: params[:uuid])
        # response = EisBilling::OneoffService.call(invoice_number: invoice.number.to_s,
        #                                           customer_url: linkpay_callback_url)
        # if response.result?
        #   redirect_to response.instance['oneoff_redirect_link'], allow_other_host: true
        # else
        #   flash.alert = response.errors['message']
        #   redirect_to invoices_path
        # end

        invoice = Invoice.find_by!(uuid: params[:uuid])
        response = Payments::Everypay::OneOffPaymentService.call(invoice:, customer_url: registrant_pay_invoices_callback_url, preferred_country: 'EE', locale: 'en')

        puts '========== response everypay =========='
        puts response
        puts '========== response everypay =========='

        if response.result?
          redirect_to response.payload['payment_link'], allow_other_host: true
        else
          flash.alert = response.errors['message']
          redirect_to root_path
        end
      end

#       ===== PAYEMENT CALLBACK =====
# {"order_reference"=>"1000", "payment_reference"=>"f00efd7665d0d663472677259469214d76395825b0330ec3e2049ae4ec7d9027", "controller"=>"registrant/invoices/pay_invoices", "action"=>"callback"}
# ===== PAYEMENT CALLBACK =====

      def callback
        puts '===== PAYEMENT CALLBACK ====='
        puts params
        puts '===== PAYEMENT CALLBACK ====='

        invoice_number = params[:order_reference]
        payment_reference = params[:payment_reference]

        response = Payments::Everypay::EverypayResponse.call(payment_reference)
        parsed_response = parse_response(response)

        puts '==='
        puts parsed_response
        puts '==='

        status = parsed_response[:payment_state] == 'settled' ? :paid : :failed

        invoice = Invoice.find_by!(number: invoice_number)
        invoice.update!(status: status)

        redirect_to registrant_domains_path
      end

      private


  def parse_response(response)
    {
      account_name: response['account_name'],
      order_reference: response['order_reference'],
      email: response['email'],
      customer_ip: response['customer_ip'],
      customer_url: response['customer_url'],
      payment_created_at: response['payment_created_at'],
      initial_amount: response['initial_amount'],
      standing_amount: response['standing_amount'],
      payment_reference: response['payment_reference'],
      payment_link: response['payment_link'],
      api_username: response['api_username'],
      warnings: response['warnings'],
      stan: response['stan'],
      fraud_score: response['fraud_score'],
      payment_state: response['payment_state'],
      payment_method: response['payment_method'],
      ob_details: response['ob_details'],
      creditor_iban: response['creditor_iban'],
      ob_payment_reference: response['ob_payment_reference'],
      ob_payment_state: response['ob_payment_state'],
      transaction_time: response['transaction_time']
    }
  end
    end
  end
end