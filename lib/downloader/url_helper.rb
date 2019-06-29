require 'addressable/uri'

require "downloader/filename_utils"
require 'downloader/loggable'

module Downloader

  # Helper class for extracting and/or manipulating URL segments.
  # Uses Addressable::URI for parsing.

  class UrlHelper
    extend Loggable

    # include % for escaped characters
    FILENAME_REGEX = %r{\/(?<filename>[a-zA-Z0-9%!_.,\-]+)$}

    # TODO: add escaping, etc
    def self.sanitize(url)
      return "" unless url
      url.strip
    end

    # Returns the filename to be used for the file at +url+
    #
    # Sets the filename to +number+ if +numbered_filenames+ is true, otherwise returns the original filename

    def self.create_filename(url, numbered_filenames, number)
      # logger.debug("Create numbered filenames? #{numbered_filenames}")

      original_filename = extract_filename(url)
      numbered_filenames ?
        FilenameUtils.rename_to_number(original_filename, number) :
        original_filename
    end

    # Returns an Addressable::URI object with the host and scheme set
    # - the host is extracted from +url+
    # - the scheme can be passed in via +user_scheme+ (eg, from the command-line options) or extracted from +url+
    #
    # Raises a UriError if either scheme or host are missing or can't be extracted

    def self.extract_host_with_scheme(url, user_scheme=nil)
      uri = Addressable::URI.parse(sanitize(url))
      host = uri.host
      scheme = user_scheme || uri.scheme

      raise UriError, "Missing scheme" unless scheme
      raise UriError, "Missing host" if host.nil? || host.empty?

      Addressable::URI.new(host: host, scheme: scheme)
    end

    # Returns the filename portion of +url+
    #
    # Raises a UriError if the filename can't be extracted

    def self.extract_filename(url)
      uri = Addressable::URI.parse(sanitize(url)).normalize
      path = uri.path

      filename = path.slice(FILENAME_REGEX, "filename")&.chomp

      raise UriError, "Cannot extract filename from path: #{path}" unless filename

      filename
    end

    # Returns the path portion of +url+
    #
    # Raises a UriError if the path can't be extracted

    def self.extract_relative_ref(url)
      uri = Addressable::URI.parse(sanitize(url))

      raise UriError, "Cannot extract path from URL: #{url}" if uri.path.nil? || uri.path.empty?

      relative_ref = Addressable::URI.parse(uri.path)
      relative_ref.query ||= uri.query
      relative_ref.fragment ||= uri.fragment

      relative_ref
    end
  end
end
