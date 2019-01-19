require 'addressable/uri'

require "downloader/filename_utils"
require 'downloader/loggable'

module Downloader
  class UrlHelper
    extend Loggable

    # include % for escaped characters
    FILENAME_REGEX = %r{\/(?<filename>[a-zA-Z0-9%_.\-]+)$}

    # TODO: add escaping, etc
    def self.sanitize(url)
      return "" unless url
      url.strip
    end

    def self.create_filename(url, numbered_filenames, number)
      # logger.debug("Create numbered filenames? #{numbered_filenames}")

      original_filename = extract_filename(url)
      numbered_filenames ?
        FilenameUtils.rename_to_number(original_filename, number) :
        original_filename
    end

    def self.extract_host_with_scheme(url)
      uri = Addressable::URI.parse(sanitize(url))
      host = uri.host
      scheme = uri.scheme

      raise UriError, "Missing scheme" unless scheme

      Addressable::URI.new(host: host, scheme: scheme)
    end

    def self.extract_filename(url)
      uri = Addressable::URI.parse(sanitize(url)).normalize
      path = uri.path

      filename = path.slice(FILENAME_REGEX, "filename")&.chomp

      raise UriError, "Cannot extract filename from path: #{path}" unless filename

      filename
    end

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
