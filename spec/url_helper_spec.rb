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
end
