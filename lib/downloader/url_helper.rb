module Downloader
  class UrlHelper
    HTTP_SCHEME = "http"
    HTTPS_SCHEME = "https"

    FILENAME_REGEX = %r{\/[a-zA-Z0-9_.\-]+$}

    def self.extract_host_with_scheme(url)
      uri = URI(url)
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
      uri = URI(url)
      path = uri.path

      filename = path.slice(FILENAME_REGEX)&.chomp

      raise UriError, "Cannot extract filename from path: #{path}" unless filename

      filename
    end
  end
end
