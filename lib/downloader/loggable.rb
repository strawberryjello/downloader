require 'logger'

# Provides an instance of the Ruby stdlib logger as a mixin

module Loggable

  # Returns the instance used in logger calls, eg logger.debug()

  def logger
    Loggable.logger
  end

  # Returns a new logger if the instance hasn't been created yet
  #
  # Logs to STDOUT with the format: severity - datetime: msg

  def self.logger
    new_logger = Logger.new(STDOUT)
    new_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{severity} - #{datetime}: #{msg}\n"
    end

    @logger ||= new_logger
  end
end
