require 'rails_helper'

RSpec.describe RegistrarUser, type: :model do
  describe 'associations' do
    it { should have_many(:app_sessions).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:registrar_user) }

    # it { should validate_presence_of(:code) }
    # it { should validate_uniqueness_of(:code).case_insensitive }
    # it { should validate_presence_of(:name) }
  end

  describe '.from_omniauth' do
    let(:tara_params) do
      {
        'given_name' => 'John',
        'family_name' => 'Doe',
        'id_code' => 'EE11234567890'
      }
    end

    context 'when user exists' do
      let!(:existing_user) { create(:registrar_user, code: '11234567890') }

      it 'returns the existing user with updated attributes' do
        existing_user.reload

        user = RegistrarUser.from_omniauth(tara_params)
        expect(user).to eq(existing_user)
        expect(user.name).to eq('John Doe')
        expect(user.code).to eq('11234567890')
      end
    end

    context 'when user does not exist' do
      it 'returns nil' do
        expect(RegistrarUser.from_omniauth(tara_params)).to be_nil
      end
    end
  end

  describe '#sex' do
    let(:user) { build(:registrar_user) }

    it 'returns male for identity codes starting with 1, 3, or 5' do
      expect(user.sex(identity_code: '11234567890')).to eq('male')
      expect(user.sex(identity_code: '33456789012')).to eq('male')
      expect(user.sex(identity_code: '55678901234')).to eq('male')
    end

    it 'returns female for identity codes starting with 2, 4, or 6' do
      expect(user.sex(identity_code: '22345678901')).to eq('female')
      expect(user.sex(identity_code: '44567890123')).to eq('female')
      expect(user.sex(identity_code: '66789012345')).to eq('female')
    end

    it 'returns unknown for other identity codes' do
      expect(user.sex(identity_code: '78901234567')).to eq('unknown')
    end
  end

  describe '#birthday' do
    let(:user) { build(:registrar_user) }

    it 'returns the correct birthday from the identity code' do
      expect(user.birthday(identity_code: '30303039914')).to eq(Date.parse('030303'))
    end
  end

  describe '.permitted_attributes' do
    it 'returns an array of permitted attributes' do
      expect(RegistrarUser.permitted_attributes).to eq([:username, :name, :code, :password, :password_confirmation])
    end
  end
end
