require "downloader"
require "downloader/util"
require "downloader/errors"

RSpec.describe Downloader::Util do
  describe '#rename_to_number' do
    it 'returns a filename containing a number and the original file extension' do
      expect(Downloader::Util.rename_to_number("cat.jpg", 2)).to eq("2.jpg")
    end

    it 'returns a filename containing only a number if there was no file extension' do
      expect(Downloader::Util.rename_to_number("cat", 2)).to eq("2")
    end

    it 'raises a FilenameError when number is nil' do
      expect { Downloader::Util.rename_to_number("cat.jpg", nil) }.to raise_error(Downloader::FilenameError, "Missing file number")
    end

    it 'raises a FilenameError when filename is nil' do
      expect { Downloader::Util.rename_to_number(nil, 1) }.to raise_error(Downloader::FilenameError, "Missing filename")
    end

    it 'raises a FilenameError when filename and number are nil' do
      expect { Downloader::Util.rename_to_number(nil, nil) }.to raise_error(Downloader::FilenameError, "Missing filename")
    end
  end
end
