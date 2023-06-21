module Auth
  def admin_login(user)
    post admin_sessions_path, params: { username: user.username, password: user.password }
  end

  def registrar_login_basic_auth(user)
    post registrar_sessions_url, params: { username: user.username, password: user.password }
  end

  def registrar_login_tara_auth(_user)
    raise NoImplementedError
  end

  def registrant_login_tara_auth(_user)
    raise NoImplementedError
  end

  def logout
    # delete logout_path
    Current.user = nil
  end

  def login(user)
    Current.user = user
  end

  # def admin_login_controller(user)
  #   # super_user = SuperUser.find_by(username: user.username)

  #   # if super_user&.authenticate(user.password)
  #   #   app_token = super_user.app_sessions.create
  #   #   log_in app_token
  #   # end

  #   Current.user = user
  # end

  # def registrar_login_basic_auth_controller(user)
  #   # registrar_user = RegistrarUser.find_by(username: user.username)

  #   # if registrar_user&.authenticate(user.password)
  #   #   app_token = registrar_user.app_sessions.create
  #   #   log_in app_token
  #   # end

  #   Current.user = user
  # end

end
