require 'logger'

module Loggable
  def logger
    Loggable.logger
  end

  def self.logger
    new_logger = Logger.new(STDOUT)
    new_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{severity} - #{datetime}: #{msg}\n"
    end

    @logger ||= new_logger
  end
end
