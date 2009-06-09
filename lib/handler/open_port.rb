require 'socket'

module Handler

  def open_port(host, port)
    s = TCPSocket.open(host, port)
    s.close
    true
  rescue Exception
    false
  end
  
end