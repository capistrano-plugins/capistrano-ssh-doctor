require_relative 'report/messages'

module Capistrano
  module SshDoctor
    class Report

      include Messages

      def initialize
        @report_messages = default_messages
      end

      def report_error_for(key, hosts=nil)
        error_message = send(key + "_error", hosts)
        set_error(key.to_sym, error_message)
      end

      def print
        print_header
        @report_messages.each_with_index do |(key, message), index|
          print_message(index + 1, message)
        end
        print_footer
      end

    private

      def set_error(key, message)
        @report_messages[key] = [ :error, message ]
      end

      def has_errors?
        @report_messages.any? {|key, value| value[0] == :error }
      end

      def print_header
        puts
        puts "SSH agent forwarding report"
        puts "---------------------------"
        puts
      end

      def print_message(index, message)
        puts "#{index}. [#{message[0]}] #{message[1]}"
        puts
      end

      def print_footer
        puts "----------------------"
        puts
        if has_errors?
          puts "It seems SSH agent forwarding is not set up correctly."
          puts "Follow the suggested steps described in error messages."
          puts "Errors (if more than one) are ordered by importance, so always start with the first one."
        else
          puts "It seems SSH agent forwarding is set up correctly!"
          puts "You can continue with the deployment process."
        end
      end

    end
  end
end
