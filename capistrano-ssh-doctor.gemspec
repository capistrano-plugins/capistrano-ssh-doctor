# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ssh_doctor/version'

Gem::Specification.new do |gem|
  gem.name          = 'capistrano-ssh-doctor'
  gem.version       = Capistrano::SshDoctor::VERSION
  gem.authors       = ['Bruno Sutic']
  gem.email         = ['bruno.sutic@gmail.com']
  gem.description   = <<-EOF.gsub(/^\s+/, '')
    This plugin helps you setup and debug `ssh-doctor` forwarding for Capistrano
    deployment.

    It peforms a number of checks on the local machine as well as on the
    servers. Report output with suggested next steps is provided in case there
    are any errors with the setup.
  EOF
  gem.summary       = 'This plugin helps you setup and debug `ssh-doctor` forwarding for Capistrano deployment.'
  gem.homepage      = 'https://github.com/capistrano-plugins/capistrano-ssh-doctor'

  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ['lib']

  gem.add_dependency 'capistrano', '>= 3.1'

  gem.add_development_dependency 'rake'
end
