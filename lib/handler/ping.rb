require 'ping'

module Handler

  def ping(host)
    Ping::pingecho(host, 5)
  end
  
end