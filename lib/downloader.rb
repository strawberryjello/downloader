require "downloader/version"
require 'http'

module Downloader
  # class Error < StandardError; end

  def self.batch(input_file, dest)
    urls = File.open(input_file, 'r').readlines

    # this could be made more generic,
    # eg for domains that don't end in .com
    domain = urls[0].slice(/http[s]?:\/\/[a-z0-9\.]+.com/)

    puts domain

    http = HTTP.persistent(domain)

    urls.each do |url|
      partial_url = url.sub(domain, '')
      puts partial_url

      filename = url.slice(/\/[a-zA-Z0-9_.\-]+$/).chomp
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
