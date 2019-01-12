require "downloader"
require "downloader/filename_utils"

RSpec.describe Downloader::FilenameUtils do
  describe '#rename_to_number' do
    it 'returns a filename containing a number and the original file extension' do
      expect(Downloader::FilenameUtils.rename_to_number("cat.jpg", 2)).to eq("2.jpg")
    end

    it 'returns a filename containing only a number if there was no file extension' do
      expect(Downloader::FilenameUtils.rename_to_number("cat", 2)).to eq("2")
    end
  end
end
