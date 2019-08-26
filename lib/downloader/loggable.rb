require 'logger'

# Provides an instance of the Ruby stdlib logger as a mixin.

module Loggable

  # Instance method wrapping self.logger. This is the method invoked by logger calls, eg logger.debug()
  #
  # @return [Logger] an instance of the Ruby stdlib logger

  def logger
    Loggable.logger
  end

  # Returns the existing logger, or creates a new one if nonexistent.
  # Logs to STDOUT with the format: severity - datetime: msg
  #
  # @return [Logger] an instance of the Ruby stdlib logger

  def self.logger
    new_logger = Logger.new(STDOUT)
    new_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{severity} - #{datetime}: #{msg}\n"
    end

    @logger ||= new_logger
  end
end
