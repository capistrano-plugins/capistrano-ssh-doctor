module Capistrano
  module SshDoctor
    class Report
      module Messages

        def default_messages
          {
            config_repo_url: [
              :success, '`repo_url` setting ok'
            ],
            local_private_key_exists: [
              :success, 'ssh private key file exists'
            ],
            local_agent_running_env_var: [
              :success, '`ssh-agent` process seems to be running locally'
            ],
            local_agent_running_ssh_add: [
              :success, '`ssh-agent` process recognized by `ssh-add` command'
            ],
            local_keys_added_to_agent: [
              :success, 'ssh private keys added to `ssh-agent`'
            ],
            local_repo_access: [
              :success, 'application repository accessible from local machine'
            ],
            config_password: [
              :success, 'all hosts using passwordless login'
            ],
            config_agent_forwarding: [
              :success, '`forward_agent` ok for all hosts'
            ],
            remote_agent_running: [
              :success, 'ssh agent successfully forwarded to remote hosts'
            ],
            remote_repo_access: [
              :success, 'application repository accessible from remote hosts'
            ]
          }
        end

        def config_repo_url_error(_)
          <<-EOF.gsub(/^ +/, '')
            It seems the git repository url in `repo_url` setting uses https
            protocol. Https protocol prompts for password and so git protocol
            should be used.

            Actions:
            - change `repo_url` setting in `config/deploy.rb` file to use git protocol.
            Example for github: `git@github.com:username/repo.git`
          EOF
        end

        def config_password_error(hosts)
          msg = "It seems Capistrano connects to the following hosts using password login:\n"
          msg << hosts.map(&:to_s).join(', ')
          msg.concat "\n"
          msg.concat <<-EOF.gsub(/^ +/, '')
            It is strongly suggested to use passwordless ssh login.

            Actions:
            - make sure you're *not* using password to connect to any of the  servers.
            - remove any password setting from `ssh_options` in Capistrano stage files
            (e.g. `config/deploy/production.rb`).
            By removing password configuration - the default, passwordless ssh
            connection will be used.
            - setup passwordless ssh connection for your servers
            http://askubuntu.com/questions/4830/easiest-way-to-copy-ssh-keys-to-another-machine/4833#4833
          EOF
        end

        def config_agent_forwarding_error(hosts)
          msg = "It seems Capistrano connects without ssh agent forwarding to the following hosts:\n"
          msg << hosts.join(', ')
          msg.concat "\n"
          msg.concat <<-EOF.gsub(/^ +/, '')
            Actions:
            - make sure Capistrano uses the default ssh option for `forward_agent`.
            Just remove any `forward_agent` setting from the stage file (e.g.
            `config/deploy/production.rb`) and the default, `true` value will be used.
          EOF
        end

        def local_private_key_exists_error(_)
          <<-EOF.gsub(/^ +/, '')
            Uh, oh. It seems you do not have ssh private keys generated, or they're
            not located in standard location.

            Actions:
            - here's a good guide how to generate ssh private keys and set them
            up with github
            https://help.github.com/articles/generating-ssh-keys
          EOF
        end

        def local_agent_running_env_var_error(_)
          <<-EOF.gsub(/^ +/, '')
            It seems `ssh-agent` is not running on local machine.

            Actions:
            - follow this guide
            http://mah.everybody.org/docs/ssh
          EOF
        end

        def local_agent_running_ssh_add_error(_)
          <<-EOF.gsub(/^ +/, '')
            It seems ssh-add cannot make a connection with ssh-agent process
            on local machine.

            Actions:
            - are you sure all the previous checks are passing? Make sure all
            the above checks are successful before trying to make this one
            pass
            - try adding ssh keys to ssh-agent by executing
            $ ssh-add ~/.ssh/id_rsa
            - if the above does not work follow this guide to setup ssh-agent process
            http://mah.everybody.org/docs/ssh
          EOF
        end

        def local_keys_added_to_agent_error(_)
          <<-EOF.gsub(/^ +/, '')
            It seems local ssh-agent process has no loaded keys.

            Actions:
            - add ssh private key to ssh-agent with this command
            $ ssh-add /path/to/ssh_private_key
            If ssh private key is in a standard location, then you most likely need this
            $ ssh-add ~/.ssh/id_rsa
          EOF
        end

        def local_repo_access_error(_)
          <<-EOF.gsub(/^ +/, '')
            It seems git application repository cannot be accessed from local machine.

            Actions:
            - here's a guide to setting passwordless access to github repositories.
            You should most likely follow just steps 3 and 4 from the guide if
            all the previous checks are successful.
            https://help.github.com/articles/generating-ssh-keys#step-3-add-your-ssh-key-to-github
          EOF
        end

        def remote_agent_running_error(hosts)
          msg = "It seems Capistrano did not succeed in making ssh agent forwarding for these hosts:\n"
          msg << hosts.join(', ')
          msg.concat "\n"
          msg.concat <<-EOF.gsub(/^ +/, '')
            Actions:
            - make sure all the previous checks pass
          EOF
        end

        def remote_repo_access_error(hosts)
          msg = "It seems Capistrano cannot access application git repository from these hosts:\n"
          msg << hosts.join(', ')
          msg.concat "\n"
          msg.concat <<-EOF.gsub(/^ +/, '')
            Actions:
            - make sure all the previous checks pass. That should make this one work too.
          EOF
        end

      end
    end
  end
end
