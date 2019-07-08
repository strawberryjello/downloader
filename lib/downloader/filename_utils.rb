module Downloader

  # Utils class for manipulating filenames

  class FilenameUtils

    # Returns a new filename with +number+ as the base, followed by the extension
    # from +filename+
    #
    # Example
    #
    #   rename_to_number("cat.jpg", "1") # => "1.jpg"

    def self.rename_to_number(filename, number)
      raise FilenameError, "Missing filename" unless filename
      raise FilenameError, "Missing file number" unless number

      extension = File.extname(filename)

      "#{number}#{extension}"
    end
  end
end
