require 'addressable/uri'

require "downloader/util"
require 'downloader/loggable'

module Downloader

  # Helper class for extracting and/or manipulating URL segments.
  # Uses Addressable::URI for parsing.

  class UrlHelper
    extend Loggable

    # Returns +url+ with extraneous special characters removed.
    #
    # Currently only strips whitespace on both ends of +url+.
    #
    # @param url [String] the URL
    # @return [String] the URL minus special characters, or the empty string if URL is nil

    def self.sanitize(url)
      return "" unless url
      url.strip
    end

    # Returns the filename to be used for the file at +url+.
    #
    # Sets the file basename to +number+ if +numbered_filenames+ is true, otherwise returns the original filename.
    # File extensions are left intact if present.
    #
    # Raises a UriError if the URL is nil/empty.
    #
    # @param url [String] the URL
    # @param numbered_filenames [Boolean] determines whether the filename portion of the URL will be replaced with a number
    # @param number [Numeric] the number to be used in the filename if +numbered_filenames+ is true
    # @return [String] the original filename, or the filename with the base replaced by +number+
    #
    # Example:
    #
    #   create_filename("https://example.com/cats/bleh.jpg", true, 1)
    #   # => "1.jpg"

    def self.create_filename(url, numbered_filenames, number)
      raise UriError, "Missing URL" if url.nil? || url.empty?

      # logger.debug("Create numbered filenames? #{numbered_filenames}")

      original_filename = extract_filename(url)
      numbered_filenames ?
        Util.rename_to_number(original_filename, number) :
        original_filename
    end

    # Returns an Addressable::URI object with the host and scheme set.
    # - the host is extracted from +url+
    # - the scheme can be passed in via +user_scheme+ (eg, from the command-line options) or extracted from +url+
    #
    # Raises a UriError if either scheme or host are missing or can't be extracted.
    #
    # @param url [String] the URL
    # @param user_scheme [String] the URL's scheme passed in via command-line
    # @return [Addressable::URI] an Addressable::URI object with the host and scheme set
    #
    # Example:
    #
    #   extract_host_with_scheme("https://example.com/cats")
    #   # => #<Addressable::URI:0x2b11e0125d14 URI:https://example.com>

    def self.extract_host_with_scheme(url, user_scheme=nil)
      uri = Addressable::URI.parse(sanitize(url))
      host = uri.host
      scheme = user_scheme || uri.scheme

      raise UriError, "Missing scheme" unless scheme
      raise UriError, "Missing host" if host.nil? || host.empty?

      Addressable::URI.new(host: host, scheme: scheme)
    end

    # Returns the filename portion of +url+.
    #
    # Raises a UriError if the filename can't be extracted.
    #
    # @param url [String] the URL
    # @return [String] the filename portion of the URL
    #
    # Example:
    #
    #   extract_filename("https://example.com/cats/catting.jpg")
    #   # => "catting.jpg"

    def self.extract_filename(url)
      uri = Addressable::URI.parse(sanitize(url)).normalize

      filename = uri.basename

      raise UriError, "Cannot extract filename from URL: #{url}" if filename.nil? || filename.empty?

      filename
    end

    # Returns an Addressable::URI object containing the path portion of +url+.
    # Includes the query and fragment portions if present.
    #
    # Raises a UriError if the path can't be extracted.
    #
    # @param url [String] the URL
    # @return [Addressable::URI] an Addressable::URI object with the path set
    #
    # Example:
    #
    #   extract_relative_ref("https://example.com/cats/catting.jpg")
    #   # => "/cats/catting.jpg"

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
