require "downloader/version"
require "downloader/errors"
require "downloader/loggable"
require "downloader/url_helper"
require 'http'
require 'uri'

module Downloader
  extend Loggable

  def self.read_input_file(file)
    begin
      File.open(file, 'r').
        readlines(chomp: true).
        reject { |u| u.empty? }
    rescue SystemCallError
      logger.error("Could not load input file: #{file}")
      exit
    end
  end

  def self.get_host_with_scheme(url, options)
    begin
      options&.dig("scheme_host") || UrlHelper.extract_host_with_scheme(url)
    rescue UriError => e
      logger.error("Error while parsing scheme: #{e}")
      logger.error(%q(
Possible solutions:
- Check your input file. If the URLs are relative, use the
  --scheme-host option to provide the scheme and host.
- If using the --scheme-host option, check if it's correct.
- If the URLs are absolute, check if the scheme and host are
  correct.
Note: Only http and https are supported.
        ))
      exit
    end
  end

  def self.do_get(http, ref)
    response = http.get(ref)
    logger.debug(response.status)

    if HTTP::Redirector::REDIRECT_CODES.include?(response.status.code)
      response = http.follow.get(ref)
      logger.debug("Followed redirect, new response status: #{response.status}")
    end

    # to_s must be called so the response will be consumed
    # before the next (persistent) request is made
    response.body.to_s
  end

  # TODO: refactor this
  def self.batch(input_file, dest, options=nil)
    logger.debug("Options: #{options}")

    urls = read_input_file(input_file)
    host_with_scheme = get_host_with_scheme(urls[0], options)

    logger.info("Connecting to #{host_with_scheme}")

    http = HTTP.persistent(host_with_scheme)

    urls.each_with_index do |url, i|
      relative_ref = UrlHelper.extract_relative_ref(url)

      # note & operator and Hash#dig: just in case options is nil
      filename = UrlHelper.create_filename(url, options&.dig('numbered_filenames'), i+1)
      logger.info("Downloading #{relative_ref} - filename: #{filename}")

      File.open(File.join(dest, filename), 'w') do |f|
        f.write(do_get(http, relative_ref))
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
