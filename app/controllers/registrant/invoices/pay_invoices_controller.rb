module Registrant
  module Invoices
    class PayInvoicesController < ApplicationController
      include Roles::RegistrantAbilitable

      def create
        invoice = Invoice.find_by!(uuid: params[:uuid])
        response = Payments::Everypay::OneOffPaymentService.call(invoice:, customer_url: registrant_pay_invoices_callback_url, preferred_country: 'EE', locale: 'en')

        if response.result?
          redirect_to response.payload['payment_link'], allow_other_host: true
        else
          flash.alert = response.errors['message']
          redirect_to root_path
        end
      end

      def callback
        invoice_number = params[:order_reference]
        payment_reference = params[:payment_reference]

        response = Payments::Everypay::EverypayResponse.call(payment_reference)
        parsed_response = parse_response(response)

        status = parsed_response[:payment_state] == 'settled' ? :paid : :failed

        invoice = Invoice.find_by!(number: invoice_number)
        
        if invoice.update(status: status)
          DomainServices::CreateDomainService.new(invoice.pending_action).call

          flash.notice = t('.domain_is_creating')
        else
          flash.alert = t('.failed')
        end

        redirect_to registrant_domains_path, status: :see_other
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