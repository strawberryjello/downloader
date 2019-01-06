require "downloader/version"
require "downloader/errors"
require 'http'
require 'uri'

module Downloader
  # TODO: move to utility class in separate file
  def self.extract_domain(url)
    uri = URI(url)
    host = uri.host
    scheme = uri.scheme

    raise UriError, "Missing scheme" unless scheme

    case (scheme)
    when 'https'
      URI::HTTPS.build(host: host)
    when 'http'
      URI::HTTP.build(host: host)
    else
      raise UriError, "Scheme not implemented: #{scheme}"
    end
  end

  def self.batch(input_file, dest)
    # TODO: add file error handling (new error class)
    urls = File.open(input_file, 'r').readlines

    domain = extract_domain(urls[0])

    puts domain

    http = HTTP.persistent(domain)

    urls.each do |url|
      partial_url = URI(url).path
      puts partial_url

      filename = partial_url.slice(/\/[a-zA-Z0-9_.\-]+$/).chomp
      File.open(File.join(dest, filename), 'w') do |f|
        f.write(http.get(partial_url))
      end
    end

    http.close
  end

  def self.download(url, file)
    File.open(file, 'w') do |f|
      f.write(HTTP.get(url))
    end
  end
end
