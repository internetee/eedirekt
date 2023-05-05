module ApplicationHelper
  include Pagy::Frontend

  def admin?
    current_user&.class&.name == 'SuperUser'
  end

  def registrar?
    current_user&.class&.name == 'RegistrarUser'
  end

  def registrant?
    current_user&.class&.name == 'User'
  end
end
