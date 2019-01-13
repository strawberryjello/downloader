require "downloader/version"
require "downloader/errors"
require "downloader/url_helper"
require 'http'
require 'logger'
require 'uri'

module Downloader

  # TODO: refactor this
  def self.batch(input_file, dest, options=nil)
    logger = Logger.new(STDOUT)

    logger.debug("Options: #{options}")

    # TODO: add file error handling (new error class)
    urls = File.open(input_file, 'r').readlines

    host_with_scheme = UrlHelper.extract_host_with_scheme(urls[0])

    logger.info("Connecting to #{host_with_scheme}")

    http = HTTP.persistent(host_with_scheme)

    urls.each_with_index do |url, i|
      relative_ref = UrlHelper.extract_relative_ref(url)

      # note & operator and Hash#dig: just in case options is nil
      filename = UrlHelper.create_filename(url, options&.dig("numbered_files"), i+1)
      logger.info("Downloading #{relative_ref} - filename: #{filename}")

      File.open(File.join(dest, filename), 'w') do |f|
        f.write(http.get(relative_ref))
      end
    end

    http.close
  end

  def self.download(url)
    filename = UrlHelper.extract_filename(url)

    File.open(filename, 'w') do |f|
      f.write(HTTP.get(url))
    end

    filename
  end
end
