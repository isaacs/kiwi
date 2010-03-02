
helpers do
  
  ##
  # Requires and returns authentication credentials.
  
  def credentials
    auth = Rack::Auth::Basic::Request.new request.env
    fail 'http basic auth credentials required' unless auth.provided? && auth.basic?
    auth.credentials
  end
  
  ##
  # Attempt to authenticate via HTTP basic auth, and assign
  # @user to the current user or fail.
  
  def require_authentication
    name, password = credentials
    @user = User.first(:name => name, :password => md5(password)) or fail 'failed to authenticate, register first'
  end
  
  ##
  # Fail with terminal-friendly _msg_. Appends ".\n".
  
  def fail msg
    error "#{msg}.\n"
  end
  
  ##
  # Require existance of _seed_ and optional _version_.
  
  def require_seed seed, version = nil
    not_found 'seed does not exist.' unless seed.exists?
    if version
      not_found 'seed version does not exist.' unless seed.exists? version
    end
  end
  
  ##
  # Return an MD5 hash of the given _str_.
  
  def md5 str
    Digest::MD5.hexdigest str
  end
end