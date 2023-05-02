require 'rails_helper'

RSpec.describe AppSession, type: :model do
  describe 'associations' do
    it { should belong_to(:sessionable) }
  end

  describe 'token creation' do
    let(:user) { create(:user) }
    let(:app_session) { create(:app_session, sessionable: user) }

    it 'generates a token before creation' do
      expect(app_session.token).not_to be_nil
    end
  end

  describe 'to_h' do
    let(:user) { create(:user) }
    let(:app_session) { create(:app_session, sessionable: user) }

    it 'returns a hash representation of the app session' do
      expect(app_session.to_h).to eq(
        sessionable_type: 'User',
        sessionable_id: user.id,
        app_session: app_session.id,
        token: app_session.token
      )
    end
  end
end
