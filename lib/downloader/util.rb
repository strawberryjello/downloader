module Downloader

  class Util

    # Writes +data+ to the file at +path+. This will overwrite the file's contents
    # if it already exists.
    #
    # Returns the length written to the file (see Ruby documentation for IO::write)
    #
    # @param path [String] path to file to be written to
    # @param data [String] data to be written to the file
    # @return [Numeric] length written to the file
    #
    # Example:
    #
    #   write_to_file("test.txt", "hello") # => 5

    def self.write_to_file(path, data)
      File.write(path, data)
    end

    # Returns the contents of +file+ as an array of lines after removing empty lines and newlines
    #
    # Exits with a nonzero value (1) when +file+ can't be loaded
    #
    # @param file [String] the input file
    # @return [Array] the non-empty lines in the input file
    #
    # Example:
    #
    #   read_input_file("test.txt") # file contains the string hello
    #   => ["hello"]

    def self.read_input_file(file)
      begin
        File.open(file, 'r').
          readlines(chomp: true).
          reject { |u| u.empty? }
      rescue SystemCallError
        logger.error("Could not load input file: #{file}")
        exit(1)
      end
    end

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
