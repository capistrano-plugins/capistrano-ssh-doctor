# Capistrano SSH Doctor

This plugin helps you setup and debug `ssh-agent` forwarding for Capistrano
deployment.

It's created to complement the official
[capistrano authentication guide](http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/).

The following is presumed:
- you're using `git`
- you want to use passwordless ssh to login to the servers
- you want to use the `ssh-agent` forwarding strategy for checking out code in
the remote repository (btw. good choice, it's a least hassle)

The plugin will report errors (and offer steps to solution) if you deviate from
this configuration. The above assumptions should hold true for 98% users.

`capistrano-ssh-doctor` works only with Capistrano **3+**.

### Who should use it?

The plugin is made for beginners and users that are not sure if their setup is
good, so they want to confirm or debug it.

### Installation

Put the following in your application's `Gemfile`:

    group :development do
      gem 'capistrano', '~> 3.2.1'
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

A number of checks will be performed and you'll get a report at the end.

#### Solving Errors

In case there are errors in your setup, specific instructions for next
steps will be provided in report output.

**Important:** errors should be tackled in the order of their output. So, if
you get errors 2, 5 and 7 in the report, start by solving error 2.

It is very probable that "solving" one or two initial errors will actually make
everything work. A lot of the checks are inter-dependent. So don't be
discouraged if you see a lot of the errors in the beginning.

Once you solved a problem, run the `ssh:doctor` task again to see the
progress.

Repeat the process until `ssh:doctor` task reports success for all the
tasks. You're ok with proceeding with the deployment then.

### Which checks are performed?

1. checks that you're using `git` as a `scm`
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

Check out [capistrano-plugins](https://github.com/capistrano-plugins) github org.

### Contributing and bug reports

If you got stuck at some point and really can't find a solution, please open a
github issue and maybe I can help. Also, your problem can be used to improve
this plugin and help others.

### License

[MIT](LICENSE.md)
