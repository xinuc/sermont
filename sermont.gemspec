# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sermont}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nugroho Herucahyono"]
  s.date = %q{2009-06-10}
  s.default_executable = %q{sermont}
  s.description = %q{Sermont is a command line based script to monitor your servers.}
  s.email = %q{xinuc@xinuc.org}
  s.executables = ["sermont"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "bin/sermont",
     "lib/config/sermont.yaml",
     "lib/handler/ftp.rb",
     "lib/handler/http.rb",
     "lib/handler/mysql.rb",
     "lib/handler/open_port.rb",
     "lib/handler/ping.rb",
     "lib/sermont.rb",
     "sermont.gemspec",
     "spec/sermont.yaml",
     "spec/sermont_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/xinuc/sermont}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{indofaker}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Server Monitor}
  s.test_files = [
    "spec/sermont_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<daemons>, [">= 1.0.10"])
      s.add_runtime_dependency(%q<term-ansicolor>, [">= 1.0.3"])
    else
      s.add_dependency(%q<daemons>, [">= 1.0.10"])
      s.add_dependency(%q<term-ansicolor>, [">= 1.0.3"])
    end
  else
    s.add_dependency(%q<daemons>, [">= 1.0.10"])
    s.add_dependency(%q<term-ansicolor>, [">= 1.0.3"])
  end
end
