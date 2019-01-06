module Downloader
  class UrlHelper
    HTTP_SCHEME = "http"
    HTTPS_SCHEME = "https"

    def self.extract_domain(url)
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
  end
end
