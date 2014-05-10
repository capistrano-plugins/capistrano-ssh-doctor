require 'capistrano/ssh_doctor/report'

namespace :ssh do

  def report
    @report ||= Capistrano::SshDoctor::Report.new
  end

  namespace :config do

    task :git do
      unless fetch(:scm) == :git
        puts 'It seems you are NOT using git as a Capistrano strategy. At the moment capistrano-ssh-doctor supports only git.'
        puts 'Please change `scm` setting to `:git`.'
        exit 1
      end
    end

    task :repo_url do
      if fetch(:repo_url) =~ /^http/
        report.report_error_for('config_repo_url')
      end
    end

    task :password do
      hosts = []
      on release_roles :all do
        if host.netssh_options[:password]
          hosts << host
        end
      end
      report.report_error_for('config_password', hosts) if hosts.any?
    end

    task :agent_forwarding do
      hosts = []
      on release_roles :all do
        unless host.netssh_options[:forward_agent]
          hosts << host
        end
      end
      report.report_error_for('config_agent_forwarding', hosts) if hosts.any?
    end

  end

  namespace :local do

    task :private_key_exists do
      specified_keys = fetch(:ssh_options, {})[:keys] || ''
      unless File.exists?(File.expand_path('~/.ssh/id_rsa')) ||
        File.exists?(File.expand_path('~/.ssh/id_dsa')) ||
        File.exists?(specified_keys)
        report.report_error_for('local_private_key_exists')
      end
    end

    task :agent_running_env_var do
      unless ENV.include?('SSH_AUTH_SOCK')
        report.report_error_for('local_agent_running_env_var')
      end
    end

    task :agent_running_ssh_add do
      if !system('ssh-add -l')
        if $? == 2
          report.report_error_for('local_agent_running_ssh_add')
        elsif $? == 1
          report.report_error_for('local_keys_added_to_agent')
        end
      end
    end

    task :repo_access do
      unless system({ 'GIT_ASKPASS' => '/bin/echo' }, "git ls-remote #{fetch(:repo_url)}")
        report.report_error_for('local_repo_access')
      end
    end

  end

  namespace :remote do

    task :agent_running do
      hosts = []
      on release_roles :all do
        if capture(:echo, '$SSH_AUTH_SOCK').empty?
          hosts << host
        end
      end
      report.report_error_for('remote_agent_running', hosts) if hosts.any?
    end

    task repo_access: :'git:wrapper' do
      hosts = []
      on release_roles :all do
        with fetch(:git_environmental_variables) do
          hosts << host unless strategy.check
        end
      end
      report.report_error_for('remote_repo_access', hosts) if hosts.any?
    end

  end

  desc 'Perform ssh doctor checks'
  task :doctor do
    invoke 'ssh:config:git'
    invoke 'ssh:config:repo_url'
    invoke 'ssh:config:password'
    invoke 'ssh:config:agent_forwarding'
    invoke 'ssh:local:private_key_exists'
    invoke 'ssh:local:agent_running_env_var'
    invoke 'ssh:local:agent_running_ssh_add'
    invoke 'ssh:local:repo_access'
    invoke 'ssh:remote:agent_running'
    invoke 'ssh:remote:repo_access'
    report.print
  end

end
