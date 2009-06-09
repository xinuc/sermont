require "rubygems"
require "yaml"
require "fileutils"
begin
  require "term/ansicolor"
rescue LoadError
end

begin
  require "daemons"
rescue LoadError
end

Dir[File.dirname(__FILE__) + '/handler/*.rb'].each{|h| require h}

class Sermont
  
  include Handler
  begin
    include Daemonize
  rescue NameError
  end
  begin
    include Term::ANSIColor
  rescue NameError
  end

  W = 80

  req_dir = File.expand_path("~/.sermont")
  Dir[req_dir + '/*.rb'].each{|h| require h} if File.exists? req_dir

  def initialize
    @raw = !(defined?(Term::ANSIColor) && self.is_a?(Term::ANSIColor))
    @can_daemon = defined?(Daemonize) && self.is_a?(Daemonize)
  end

  def load_setup
    config_file = File.expand_path("~/.sermont.yml")
    unless File.exists?(config_file) && @servers = YAML.load(IO.read(config_file))
      puts "Config file .sermont.yml doesn't exists or invalid."
      puts "Run  'sermont --setup' to create example config file in your home directory"
      exit
    end
  end

  def run(raw = nil, time = nil, output = nil, daemon = nil)
    load_setup
    @raw = @raw || raw
    unless time
      output ? add_to_output(report, output) : print(report)
    else
      if daemon && @can_daemon && output
        pwd = Dir.pwd
        daemonize
        Dir.chdir pwd
      end
      loop do
        output ? add_to_output(report, output) : print(report)
        begin
          sleep time.to_i
        rescue Exception
          exit
        end
      end
    end
  end

  def add_to_output(out, file)
    File.open(file, "ab") do |f|
      f << out
    end
  end

  def report
    report = notification(Time.now.to_s)
    @servers.each do |server|
      servername = server["servername"]
      ip = server["ip"]
      report << handle_host(servername, ip)
      services = server["services"]
      services.each do |k, v|
        report << handle_service(k, ip, v)
      end
    end
    report
  end

  def notification(notif)
    if @raw
      notif + whitespace(notif) + "\n"
    else
      on_black + dark + notif + whitespace(notif) + clear + "\n"
    end
  end

  def whitespace(str)
    spaces = W - str.size
    w = ""
    spaces.times {w << " "}
    w
  end

  def dotspace(str, f_indent, b_indent)
    spaces = W - 4 - str.size - f_indent - b_indent
    w = ""
    spaces.times {w << "."}
    w
  end

  def host_str(hostname)
    if @raw
      "#{hostname} is " + dotspace(hostname, 0, 10)
    else
      on_yellow + black + bold + "#{hostname} is " + dotspace(hostname, 0, 10) + clear
    end
  end

  def host_status(alive)
    if alive
      @raw ? "Alive     \n" : bold + on_green + white + "Alive     " + clear + "\n"
    else
      @raw ? "In Trouble\n" : bold + on_red + white + "In Trouble" + clear + "\n"
    end
  end

  def handle_host(servername, ip)
    host_str(servername) + host_status(self.ping ip)
  end

  def service_str(service)
    if @raw
      "     #{service} is " + dotspace(service, 5, 10)
    else
      on_blue + yellow + bold + "     #{service} is " + dotspace(service, 5, 10) + clear
    end
  end

  def service_status(running)
    if running
      @raw ? "Running   \n" : bold + on_green + white + "Running   " + clear + "\n"
    else
      @raw ? "Stopped   \n" : bold + on_red + white + "Stopped   " + clear + "\n"
    end
  end

  def handle_service(handler, ip, port)
    running = begin
      self.send(handler, ip, port)
    rescue NoMethodError
      self.open_port(ip, port)
    end
    service_str(handler) + service_status(running)
  end
  
end