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

    desc "download URL", "download URL to current directory"
    def download(url)
      Downloader.download(url)
    end
  end
end
