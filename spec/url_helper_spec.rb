require "downloader"
require "downloader/url_helper"
require "downloader/errors"
require 'uri'

RSpec.describe Downloader::UrlHelper do
  describe '#extract_host_with_scheme' do
    it 'extracts the host and scheme of a URL as one string' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com")).to eq(URI("https://www.example.com"))
    end

    it 'ignores the userinfo' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://user@www.example.com/")).to eq(URI("https://www.example.com"))
    end

    it 'ignores the port' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com:0000/")).to eq(URI("https://www.example.com"))
    end

    it 'ignores the path' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com/cats/blep")).to eq(URI("https://www.example.com"))
    end

    it 'ignores the query string' do
      expect(Downloader::UrlHelper.extract_host_with_scheme("https://www.example.com/cats?mlem=true&feets=curled")).to eq(URI("https://www.example.com"))
    end

    it 'ignores fragments' do
      expect(Downloader::UrlHelper.extract_host_with_scheme('https://www.example.com/cats?mlem=true&feets=curled#bottom')).to eq(URI("https://www.example.com"))
    end

    it 'raises a UriError when scheme is missing' do
      expect { Downloader::UrlHelper.extract_host_with_scheme("www.example.com") }.to raise_error(Downloader::UriError, 'Missing scheme')
    end

    it 'raises a UriError when scheme is ftp' do
      expect { Downloader::UrlHelper.extract_host_with_scheme("ftp://www.example.com") }.to raise_error(Downloader::UriError, 'Cannot handle scheme: ftp')
    end

    it 'raises a UriError when scheme is irc' do
      expect { Downloader::UrlHelper.extract_host_with_scheme("irc://www.example.com") }.to raise_error(Downloader::UriError, 'Cannot handle scheme: irc')
    end
  end

  describe '#extract_filename' do
    it 'extracts a filename with an extension at the end of the URL path' do
      expect(Downloader::UrlHelper.extract_filename('https://www.example.com/cats/catting.jpg')).to eq('catting.jpg')
    end

    it 'extracts a filename without an extension at the end of the URL path' do
      expect(Downloader::UrlHelper.extract_filename('https://www.example.com/cats/2cat')).to eq('2cat')
    end

    it 'raises a UriError when a filename cannot be extracted' do
      expect { Downloader::UrlHelper.extract_filename('https://www.example.com/cats/') }.to raise_error(Downloader::UriError, 'Cannot extract filename from path: /cats/')
    end
  end

  describe '#extract_relative_ref' do
    it 'extracts a relative reference from a URL with a path' do
      expect(Downloader::UrlHelper.extract_relative_ref('https://www.example.com/cats')).to eq(URI('/cats'))
    end

    it 'extracts a relative reference from a URL with a path and a query string' do
      expect(Downloader::UrlHelper.extract_relative_ref('https://www.example.com/cats?id=1&tails=2')).to eq(URI('/cats?id=1&tails=2'))
    end

    it 'extracts a relative reference from a URL with a path, a query string, and a fragment' do
      expect(Downloader::UrlHelper.extract_relative_ref('https://www.example.com/cats?id=1&tails=2#bottom')).to eq(URI('/cats?id=1&tails=2#bottom'))
    end

    it 'raises a UriError when a path cannot be extracted' do
      expect { Downloader::UrlHelper.extract_relative_ref('https://www.example.com') }.to raise_error(Downloader::UriError, 'Cannot extract path from URL: https://www.example.com')
    end
  end
end
