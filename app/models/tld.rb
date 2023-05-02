class Tld < ApplicationRecord
  attr_encrypted :password, key: 'df12de12d5b150054aec8805c40da4a3'
end
