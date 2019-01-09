module Downloader
  class UrlHelper
    HTTP_SCHEME = "http"
    HTTPS_SCHEME = "https"

    FILENAME_REGEX = %r{\/(?<filename>[a-zA-Z0-9_.\-]+)$}

    # TODO: add escaping, etc
    def self.sanitize(url)
      url.strip
    end

    def self.extract_host_with_scheme(url)
      uri = URI(sanitize(url))
      host = uri.host
      scheme = uri.scheme

      raise UriError, "Missing scheme" unless scheme

      case (scheme)
      when HTTPS_SCHEME
        URI::HTTPS.build(host: host)
      when HTTP_SCHEME
        URI::HTTP.build(host: host)
      else
        raise UriError, "Cannot handle scheme: #{scheme}"
      end
    end

    def self.extract_filename(url)
      uri = URI(sanitize(url))
      path = uri.path

      filename = path.slice(FILENAME_REGEX, "filename")&.chomp

      raise UriError, "Cannot extract filename from path: #{path}" unless filename

      filename
    end

    def self.extract_relative_ref(url)
      uri = URI(sanitize(url))

      raise UriError, "Cannot extract path from URL: #{url}" if uri.path.nil? || uri.path.empty?

      relative_ref = URI(uri.path)
      relative_ref.query ||= uri.query
      relative_ref.fragment ||= uri.fragment

      relative_ref
    end
  end
end
