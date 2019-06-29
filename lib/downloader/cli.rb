require 'thor'
require 'downloader'

module Downloader

  # CLI class, extends Thor.
  #
  # Methods are exposed as commands; unless specified, params are required.
  # Usage descriptions and options are specified using Thor's syntax.

  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "batch FILE DEST", "download all URLs in FILE to DEST directory"
    option :numbered_filenames, :type => :boolean, :desc => "rename files to be downloaded with numbers according to their order in the input file; file extensions, if any, will be retained"
    option :scheme_host, :desc => "the scheme and host in one string, for files containing relative URLs"
    option :scheme, :desc => "the scheme, for files containing scheme-less URLs"
    def batch(input_file, dest)
      Downloader.batch(input_file, dest, options)
    end

    desc "download URL", "download URL to current directory"
    def download(url)
      Downloader.download(url)
    end
  end
end
