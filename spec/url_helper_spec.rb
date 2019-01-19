# coding: utf-8
require "downloader"
require "downloader/url_helper"
require "downloader/errors"
require "addressable/uri"

RSpec.describe Downloader::UrlHelper do
  describe '#sanitize' do
    it 'strips whitespace from the input URL' do
      expect(Downloader::UrlHelper.sanitize("\n https://www.example.com\n ")).to eq("https://www.example.com")
    end

    it 'returns the input URL unchanged if it has no leading or trailing whitespace' do
      expect(Downloader::UrlHelper.sanitize("https://www.example.com")).to eq("https://www.example.com")
    end

    it 'returns an empty string when the input URL is an empty string' do
      expect(Downloader::UrlHelper.sanitize("")).to eq("")
    end

    it 'returns an empty string when the input URL is nil' do
      expect(Downloader::UrlHelper.sanitize(nil)).to eq("")
    end
  end

  describe '#create_filename' do
    it 'creates a filename extracted from a URL when numbered_files=nil and number=nil' do
      expect(Downloader::UrlHelper.create_filename("https://www.example.com/cat.jpg", nil, nil)).to eq("cat.jpg")
    end

    it 'creates a filename extracted from a URL when numbered_files=nil and number is not nil' do
      expect(Downloader::UrlHelper.create_filename("https://www.example.com/cat.jpg", nil, 1)).to eq("cat.jpg")
    end

    it 'creates a filename extracted from a URL when numbered_files=false and number=nil' do
      expect(Downloader::UrlHelper.create_filename("https://www.example.com/cat.jpg", false, nil)).to eq("cat.jpg")
    end

    it 'creates a filename extracted from a URL when numbered_files=false and number is not nil' do
      expect(Downloader::UrlHelper.create_filename("https://www.example.com/cat.jpg", false, 1)).to eq("cat.jpg")
    end

    it 'creates a numbered filename when numbered_files=true and number is not nil' do
      expect(Downloader::UrlHelper.create_filename("https://www.example.com/cat.jpg", true, 1)).to eq("1.jpg")
    end

    it 'raises a FilenameError when numbered_files=true and number=nil' do
      expect { Downloader::UrlHelper.create_filename("https://www.example.com/cat.jpg", true, nil) }.to raise_error(Downloader::FilenameError, "Missing file number")
    end

    it 'raises a UriError when URL is nil' do
      expect { Downloader::UrlHelper.create_filename(nil, nil, nil) }.to raise_error(Downloader::UriError, "Cannot extract filename from path: ")
    end
  end

  describe '#extract_host_with_scheme' do
    it 'extracts the host and scheme of a URL as one string' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com")).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'extracts the host and scheme of a URL with a newline at the end' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com\n")).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'ignores the userinfo' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://user@www.example.com/")).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'ignores the port' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com:0000/")).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'ignores the path' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com/cats/blep")).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'ignores the query string' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com/cats?mlem=true&feets=curled")).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'ignores fragments' do
      expect(Downloader::UrlHelper.extract_host_with_scheme('https://www.example.com/cats?mlem=true&feets=curled#bottom')).to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it 'raises a UriError when scheme is missing' do
      expect { Downloader::UrlHelper.extract_host_with_scheme("www.example.com") }.to raise_error(Downloader::UriError, 'Missing scheme')
    end
  end

  describe '#extract_filename' do
    it 'extracts a filename with escaped Unicode characters and an extension from a URL with unescaped Unicode characters' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/[CM]-←-catting.jpg")).to eq("%5BCM%5D-%E2%86%90-catting.jpg")
    end

    it 'extracts a filename with an extension at the end of the URL path' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/catting.jpg")).to eq("catting.jpg")
    end

    it 'extracts a filename with an extension at the end of the URL path and a newline' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/catting.jpg\n")).to eq("catting.jpg")
    end

    it 'extracts a filename without an extension at the end of the URL path' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/2cat")).to eq("2cat")
    end

    it 'extracts a filename without an extension at the end of the URL path and a newline' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/2cat\n")).to eq("2cat")
    end

    it 'extracts a filename with an extension from a URL with a query string' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/catting.jpg?id=1&floof=true")).to eq("catting.jpg")
    end

    it 'extracts a filename with an extension from a URL with a query string and a newline' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/catting.jpg?id=1&floof=true\n")).to eq("catting.jpg")
    end

    it 'extracts a filename with an extension from a URL with a fragment' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/catting.jpg#top")).to eq("catting.jpg")
    end

    it 'extracts a filename with an extension from a URL with a fragment and a newline' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/catting.jpg#top\n")).to eq("catting.jpg")
    end

    it 'extracts a filename without an extension from a URL with a query string' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/2cat?id=1&floof=true")).to eq("2cat")
    end

    it 'extracts a filename without an extension from a URL with a query string and a newline' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/2cat?id=1&floof=true\n")).to eq("2cat")
    end

    it 'extracts a filename without an extension from a URL with a fragment' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/2cat#top")).to eq("2cat")
    end

    it 'extracts a filename without an extension from a URL with a fragment and a newline' do
      expect(Downloader::UrlHelper.extract_filename("https://www.example.com/cats/2cat#top\n")).to eq("2cat")
    end

    it 'raises a UriError when a filename cannot be extracted' do
      expect { Downloader::UrlHelper.extract_filename("https://www.example.com/cats/") }.to raise_error(Downloader::UriError, "Cannot extract filename from path: /cats/")
    end
  end

  describe '#extract_relative_ref' do
    it 'extracts a relative reference from a URL with a path' do
      expect(Downloader::UrlHelper.extract_relative_ref("https://www.example.com/cats")).to eq(Addressable::URI.parse("/cats"))
    end

    it 'extracts a relative reference from a URL with a path and a newline' do
      expect(Downloader::UrlHelper.extract_relative_ref("https://www.example.com/cats\n")).to eq(Addressable::URI.parse("/cats"))
    end

    it 'extracts a relative reference from a URL with a path and a query string' do
      expect(Downloader::UrlHelper.extract_relative_ref("https://www.example.com/cats?id=1&tails=2")).to eq(Addressable::URI.parse("/cats?id=1&tails=2"))
    end

    it 'extracts a relative reference from a URL with a path and a query string and a newline' do
      expect(Downloader::UrlHelper.extract_relative_ref("https://www.example.com/cats?id=1&tails=2\n")).to eq(Addressable::URI.parse("/cats?id=1&tails=2"))
    end

    it 'extracts a relative reference from a URL with a path, a query string, and a fragment' do
      expect(Downloader::UrlHelper.extract_relative_ref("https://www.example.com/cats?id=1&tails=2#bottom")).to eq(Addressable::URI.parse("/cats?id=1&tails=2#bottom"))
    end

    it 'extracts a relative reference from a URL with a path, a query string, a fragment, and a newline' do
      expect(Downloader::UrlHelper.extract_relative_ref("https://www.example.com/cats?id=1&tails=2#bottom\n")).to eq(Addressable::URI.parse("/cats?id=1&tails=2#bottom"))
    end

    it 'raises a UriError when a path cannot be extracted' do
      expect { Downloader::UrlHelper.extract_relative_ref('https://www.example.com') }.to raise_error(Downloader::UriError, 'Cannot extract path from URL: https://www.example.com')
    end
  end
end
