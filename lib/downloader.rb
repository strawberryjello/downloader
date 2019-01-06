require "downloader/version"
require "downloader/errors"
require "downloader/url_helper"
require 'http'
require 'uri'

module Downloader
  def self.batch(input_file, dest)
    # TODO: add file error handling (new error class)
    urls = File.open(input_file, 'r').readlines

    host_with_scheme = UrlHelper.extract_host_with_scheme(urls[0])

    puts host_with_scheme

    http = HTTP.persistent(host_with_scheme)

    urls.each do |url|
      path = URI(url).path
      puts path

      filename = UrlHelper.extract_filename(url)
      File.open(File.join(dest, filename), 'w') do |f|
        f.write(http.get(path))
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
