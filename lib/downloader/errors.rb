module Downloader
  class Error < StandardError; end

  class UriError < Error; end

  # TODO: extract this if extracting FilenameUtils
  class FilenameError < Error; end
end
