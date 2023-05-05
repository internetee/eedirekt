class ApplicationRecord < ActiveRecord::Base
  include HumanEnum

  primary_abstract_class
end
