require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'from_omniauth' do
    let(:tara_params) do
      {
        'given_name' => 'John',
        'family_name' => 'Doe',
        'id_code' => '1234567890'
      }
    end
  end

  describe 'sex' do
    let(:user) { User.new }

    it 'returns male for odd first digit' do
      expect(user.sex(identity_code: '1234567890')).to eq('male')
    end

    it 'returns female for even first digit' do
      expect(user.sex(identity_code: '2234567890')).to eq('female')
    end

    it 'returns unknown for other first digits' do
      expect(user.sex(identity_code: '9234567890')).to eq('unknown')
    end
  end

  describe 'birthday' do
    let(:user) { User.new }

    it 'returns the correct birth date from identity code' do
      expect(user.birthday(identity_code: '30303039914')).to eq(Date.parse('030303'))
    end
  end  
end
