require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sermont do
  include Term::ANSIColor
  
  before(:each) do
    @sermont = Sermont.new
  end

  it "should include some modules" do
    Sermont.should include(Handler)
    Sermont.should include(Daemonize)
    Sermont.should include(Term::ANSIColor)
  end

  it "should set raw to true if can include ansicolor" do
    @sermont.instance_variable_get("@raw").should == false
    @sermont.instance_variable_get("@can_daemon").should == true
  end

  it "should load servers correctly" do
    File.stubs(:expand_path).with("~/.sermont.yml").returns(File.dirname(__FILE__) + "/sermont.yaml")
    @sermont.load_setup
    servers = @sermont.instance_variable_get("@servers")
    servers.should_not be_nil
    servers.should ==  [{"servername"=>"My Server", "ip"=>"127.0.0.1", "services"=>{"ftp"=>21, "http"=>80}}, {"servername"=>"Yet Another Server", "ip"=>"127.0.0.2", "services"=>{"ftp"=>21, "ssh"=>22, "http"=>80}}]
  end

  it "should exit if config not found" do
    File.stubs(:exists?).with(File.expand_path("~/.sermont.yml")).returns false
    @sermont.stubs(:exit).returns("EXIT")
    @sermont.load_setup.should == "EXIT"
  end

  it "should has notification of 81 chars in raw" do
    @sermont.instance_variable_set("@raw", true)
    @sermont.notification("some notif").size.should == 81
  end
  
  it "should has host str of 70 chars in raw" do
    @sermont.instance_variable_set("@raw", true)
    @sermont.host_str("some host").size.should == 70
  end
  
  it "should has service str of 70 chars in raw" do
    @sermont.instance_variable_set("@raw", true)
    @sermont.service_str("some service").size.should == 70
  end
  
  it "should has status of 11 chars in raw" do
    @sermont.instance_variable_set("@raw", true)
    @sermont.service_status(true).size.should == 11
    @sermont.service_status(false).size.should == 11
    @sermont.host_status(true).size.should == 11
    @sermont.host_status(false).size.should == 11
  end

  it "should has handle host of 81 chars in raw" do
    @sermont.instance_variable_set("@raw", true)
    @sermont.handle_host("this localhost", "127.0.0.1").size.should == 81
    @sermont.handle_host("some weird host", "167.0.0.1").size.should == 81
  end
  
  it "should has handle service of 81 chars in raw" do
    @sermont.instance_variable_set("@raw", true)
    @sermont.handle_service("http", "127.0.0.1", 80).size.should == 81
    @sermont.handle_service("ldap", "127.0.0.1", 2000).size.should == 81
  end

end
