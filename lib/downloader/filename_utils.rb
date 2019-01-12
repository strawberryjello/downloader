module Downloader
  # TODO: consider merging this with the FilenameUtils in imgd and extracting to a gem
  class FilenameUtils
    def self.rename_to_number(filename, number)
      raise FilenameError, "Missing filename" unless filename
      raise FilenameError, "Missing file number" unless number

      extension = File.extname(filename)

      "#{number}#{extension}"
    end
  end
end
