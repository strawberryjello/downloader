require 'thor'
require 'downloader'

module Downloader
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "batch FILE DEST", "download all URLs in FILE to DEST directory"
    def batch(input_file, dest)
      Downloader.batch(input_file, dest)
    end

    desc "download URL DEST", "download URL to DEST file path"
    def download(url, dest)
      Downloader.download(url, dest)
    end
  end
end
