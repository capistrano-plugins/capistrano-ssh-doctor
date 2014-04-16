require_relative 'report'

module Capistrano
  module SshDoctor
    module DSL

      def report
        Capistrano::SshDoctor::Report.report
      end

    end
  end
end
self.extend Capistrano::SshDoctor::DSL
