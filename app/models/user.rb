class User < ApplicationRecord
  include HasSession
  include Authentication

  enum gender: { male: 'male', female: 'female', unknown: 'unknown' }

  def self.from_omniauth(tara_params)
    full_name = "#{tara_params.dig('info', 'given_name')} #{tara_params.dig('info', 'family_name')}"
    code = tara_params['uid'][2..]

    user = User.find_or_initialize_by(code:)
    user.name = full_name
    user.code = code

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
