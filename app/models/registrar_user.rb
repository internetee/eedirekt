class RegistrarUser < ApplicationRecord
  include HasSession
  include Authentication

  has_secure_password validations: false

  attr_accessor :password_confirmation

  GENDER = { male: 'male', female: 'female', unknown: 'unknown' }.freeze
  validate :authentication_present
  validates :password, confirmation: true, if: :password_or_confirmation_present?
  validate :password_match, if: :password_or_confirmation_present?

  def self.from_omniauth(tara_params)
    full_name = "#{tara_params.dig('info', 'given_name')} #{tara_params.dig('info', 'family_name')}"
    code = tara_params['uid'][2..]

    user = RegistrarUser.find_by(code:)
    return if user.nil?

    user.name = full_name
    user.code = code

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
    [:username, :code, :password, :password_confirmation]
  end

  private

  def password_match
    errors.add(:password, I18n.t('errors.messages.passwords_do_not_match')) unless password == password_confirmation
  end

  def password_or_confirmation_present?
    password.present? || password_confirmation.present?
  end

  def authentication_present
    unless username.present? && password_digest.present? || code.present?
      errors.add(:base, I18n.t('errors.messages.authentication_information_missing'))
    end
  end
end
