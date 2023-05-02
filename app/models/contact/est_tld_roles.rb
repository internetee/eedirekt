module Contact::EstTldRoles
  extend ActiveSupport::Concern

  included do
    enum role: { priv: 100, org: 200 }
  end
end
