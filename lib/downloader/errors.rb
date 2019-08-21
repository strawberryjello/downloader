module Downloader
  # Generic error class
  class Error < StandardError; end

  # Error class used by UrlHelper
  class UriError < Error; end

  # Error class used by FilenameUtils
  class FilenameError < Error; end
end
