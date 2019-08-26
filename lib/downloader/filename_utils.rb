module Downloader

  # Utility class for manipulating filenames

  class FilenameUtils

    # Returns a new filename with +number+ as the base, followed by the extension
    # from +filename+.
    #
    # @param filename [String] the original filename
    # @param number [Numeric] the number to be used for renaming
    # @return [String] the new filename
    #
    # Example:
    #
    #   rename_to_number("cat.jpg", 1) # => "1.jpg"

    def self.rename_to_number(filename, number)
      raise FilenameError, "Missing filename" unless filename
      raise FilenameError, "Missing file number" unless number

      extension = File.extname(filename)

      "#{number}#{extension}"
    end
  end
end
