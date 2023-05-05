module Contact::EstTld::LegalDoc
  extend ActiveSupport::Concern

  included do
    has_one_attached :legal_document
  end
end
