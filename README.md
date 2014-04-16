# Capistrano SSH Doctor

This plugin helps you setup and debug `ssh-agent` forwarding for Capistrano
deployment.

It's created to complement the official [capistrano authentication guide](http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/).

The following is presumed:
- you're using `git`
- you want to use passwordless ssh login to the servers
- you want to use the `ssh-agent` forwarding strategy for checking out code in
the remote repository (btw. good choice, it's a least hassle)

The plugin will report errors (and offer steps to solution) if you deviate from
this configuration. The above assumptions should hold true for 98% users.

`capistrano-ssh-doctor` works only with Capistrano **3+**.

### Who should use it?

The plugin is made for beginners and users that are not sure if their setup is
good, so they want to confirm or debug it.

If you have enough knowldge/experience with `ssh` tool and you're sure you have
`ssh-agent` forwarding working for your server, you probably don't need this
plugin.

### Installation

Put the following in your application's `Gemfile`:

    group :development do
      gem 'capistrano', '~> 3.1'
      gem 'capistrano-ssh-doctor'
    end

Then run in the console:

    $ bundle install

Put the following in `Capfile` file:

    require 'capistrano/ssh_doctor'

### Usage

This plugin is intended to be used **before** any deployment task.

In the console run:

    $ bundle exec cap production ssh:doctor

The plugin will perform a number of checks and output a report at the end.

**Solving Errors**

In case there are errors in your setup, specific instructions for next
steps will be provided in report output.

**Important:** errors should be tackled in the order of their output. So, if
you got errors 2, 5 and 7 in the report, start by solving error 2.

It is very probable that "solving" one or two initial errors will actually make
everything work. A lot of the checks are inter-dependent. So don't be
discouraged if you see a lot of the errors in the beginning.

Once you solved a problem, run the `ssh:doctor` task again to see the
progress.

Repeat the process until `ssh:doctor` task reports success for all the
tasks. You're ok with proceeding with the deployment then.

### Which checks are performed?

1. checks that you're using `git` repository protocol
2. checks that ssh private key file exists locally
3. checks if `ssh-agent` process is running locally
4. checks that `ssh-add` process can communicate with `ssh-agent`
5. checks that ssh private keys are loaded to `ssh-agent`
6. checks that remote code repository is accessible from local machine
7. checks passwordless ssh login is used for all servers
8. checks `forward_agent` capistrano option is set to `true` for all servers
9. checks `ssh-agent` is actually forwared to all the servers
10. checks remote code repository is accessible from all the servers

You'll see the results for all the checks in the output of `ssh:doctor`
task.

### More Capistrano automation?

If you'd like to streamline your Capistrano deploys, you might want to check
these zero-configuration, plug-n-play plugins:

- [capistrano-unicorn-nginx](https://github.com/bruno-/capistrano-unicorn-nginx)<br/>
no-configuration unicorn and nginx setup with sensible defaults
- [capistrano-postgresql](https://github.com/bruno-/capistrano-postgresql)<br/>
plugin that automates postgresql configuration and setup
- [capistrano-rbenv-install](https://github.com/bruno-/capistrano-rbenv-install)<br/>
would you like Capistrano to install rubies for you automatically?
- [capistrano-safe-deploy-to](https://github.com/bruno-/capistrano-safe-deploy-to)<br/>
if you're annoyed that Capistrano does **not** create a deployment path for the
app on the server (default `/var/www/myapp`), this is what you need!

### Contributing and bug reports

If you got stuck at some point and really can't find a solution, please open a
[github issue](/issues) and maybe I can help you.

Also, I can use your problem to improve this plugin.

### License

[MIT](LICENSE.md)

# TODO
- do not store text in report hash, store only success/fail there
