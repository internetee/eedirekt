class SuperUser < ApplicationRecord
  include HasSession
  include Authentication

  has_secure_password
  validates :password, length: { minimum: 8 }, presence: true, on: [:create, :password_change]

  def self.permitted_attributes
    [:username, :email, :password, :password_confirmation]
  end
end
