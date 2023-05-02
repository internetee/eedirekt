require 'rails_helper'

RSpec.describe SuperUser, type: :model do
  it 'if password dismatches then subject is invalid' do
    u = SuperUser.new
    u.username = 'username'
    u.email = 'email@email.com'
    u.password = 'password1'
    u.password_confirmation = 'password2'

    expect(u.valid?).to eq false

    u.password = 'password'
    u.password_confirmation = 'password'

    expect(u.valid?).to eq true
  end
end
