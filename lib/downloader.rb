require "downloader/version"
require "downloader/errors"
require "downloader/loggable"
require "downloader/url_helper"
require 'http'
require 'uri'

module Downloader
  extend Loggable

  # Returns the contents of +file+ as an array of lines after removing empty lines and newlines
  #
  # Exits with a nonzero value (1) when +file+ can't be loaded
  #
  # @param file [String] the input file
  # @return [Array] the non-empty lines in the input file
  #
  # Example:
  #
  #   read_input_file("in.txt")

  def self.read_input_file(file)
    begin
      File.open(file, 'r').
        readlines(chomp: true).
        reject { |u| u.empty? }
    rescue SystemCallError
      logger.error("Could not load input file: #{file}")
      exit(1)
    end
  end

  # Returns the value of scheme_host in +options+ if it exists, otherwise
  # extracts the scheme and host as one string from +url+
  #
  # Exits with a nonzero value (1) and an error message with troubleshooting tips
  # when UrlHelper throws a UriError
  #
  # @param url [String] the source URL
  # @param options [Hash] the hash containing command-line options
  # @return [String] the host and scheme as one string
  #
  # Example:
  #
  #   get_host_with_scheme("https://example.com/cats", options_hash)
  #   # => "https://example.com"

  def self.get_host_with_scheme(url, options)
    begin
      options&.dig("scheme_host") ||
        UrlHelper.extract_host_with_scheme(url, options&.dig("scheme"))
    rescue UriError => e
      logger.error("Error while parsing URL: #{e}")
      logger.error(%q(
Possible solutions:
- Check your input file. If the URLs are relative, use the
  --scheme-host option to provide the scheme and host.
- If using the --scheme-host option, check if it's correct.
- If the URLs are missing a scheme but not the host, use the
  --scheme option to provide the scheme.
- If the URLs are absolute, check if the scheme and host are
  correct.
        ))
      exit(1)
    end
  end

  # Makes the HTTP GET request for +ref+ using +http+, follows redirects
  #
  # @param http [HTTP] the HTTP object provided by http.rb
  # @param ref [String] the relative ref to the file being downloaded
  # @return [String] the response body

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

  # Downloads the files pointed to by the URLs in +input_file+ to the path specified by +dest+
  #
  # @param input_file [String] the path to the file containing the URLs to be downloaded from
  # @param dest [String] the destination path
  # @param options [Hash] optional hash for command-line options, see README for full list
  #
  # Example:
  #
  #   Downloader.batch("urls.txt", ".", {})
  #   # => downloads the files from the URLs in urls.txt to the current directory

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

  # Downloads the file at +url+ to the current directory
  #
  # @param url [String] the URL of the file to be downloaded
  # @return [String] the original filename of the downloaded file

  def self.download(url)
    filename = UrlHelper.extract_filename(url)

    File.open(filename, 'w') do |f|
      f.write(HTTP.get(url))
    end

    filename
  end
end
