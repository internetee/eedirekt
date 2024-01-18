class User < ApplicationRecord
  include HasSession
  include Authentication
  include Phone

  attr_accessor :phone_code
  attr_accessor :registrar_format_phone

  has_many :pending_actions, dependent: :destroy

  enum gender: { male: 'male', female: 'female', unknown: 'unknown' }
  enum role: { priv: 100, org: 200 }

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: I18n.t('.invalid_email_format') }, allow_blank: true
  # validates :name,
  validates :role, inclusion: { in: User.roles }, allow_blank: true

  validates :ident, uniqueness: { scope: :country_code }, allow_blank: true
  validate :identity_code_must_be_valid_for_estonia, if: proc { |user|
    user.country_code.present? && user.country_code == 'EE'
  }

  validates :phone, numericality: { only_integer: true }, allow_blank: true
  validates :phone_code, numericality: { only_integer: true }, allow_blank: true

  # DON'T CHANGE THIS ORDER
  before_save :registrar_phone
  before_save :combine_phone_and_phone_code
  
  after_find :split_phone_into_code_and_number

  def self.from_omniauth(tara_params)
    full_name = "#{tara_params.dig('info', 'given_name')} #{tara_params.dig('info', 'family_name')}"
    ident = tara_params['uid'][2..]

    user = User.find_or_initialize_by(ident:)
    user.name = full_name
    user.ident = ident

    user
  end

  def sex(identity_code:)
    case identity_code[0]
    when '1', '3', '5'
      User.genders[:male]
    when '2', '4', '6'
      User.genders[:female]
    else
      User.genders[:unknown]
    end
  end

  def birthday(identity_code:)
    Date.parse(identity_code.slice(1..6))
  end

end
