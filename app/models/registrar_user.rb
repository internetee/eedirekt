class RegistrarUser < ApplicationRecord
  include HasSession
  include Authentication

  has_secure_password validations: false

  GENDER = { male: 'male', female: 'female', unknown: 'unknown' }.freeze

  # validates :code, presence: true, uniqueness: true
  # validates :name, presence: true

  def self.from_omniauth(tara_params)
    full_name = "#{tara_params['given_name']} #{tara_params['family_name']}"
    identity = tara_params['id_code'][2..]

    user = RegistrarUser.find_by(code: identity)
    return if user.nil?

    user.name = full_name
    user.code = identity

    user
  end

  def sex(identity_code:)
    case identity_code[0]
    when '1', '3', '5'
      GENDER[:male]
    when '2', '4', '6'
      GENDER[:female]
    else
      GENDER[:unknown]
    end
  end

  def birthday(identity_code:)
    Date.parse(identity_code.slice(1..6))
  end

  def self.permitted_attributes
    [:username, :name, :code, :password, :password_confirmation]
  end
end
