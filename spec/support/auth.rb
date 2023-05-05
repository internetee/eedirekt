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
    delete logout_path
  end
end
