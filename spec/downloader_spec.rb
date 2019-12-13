require "downloader"
require "addressable/uri"

RSpec.describe Downloader do
  describe '::get_host_with_scheme' do
    it "returns the scheme_host option if provided" do
      scheme_host = "http://cat.net"
      options = {'scheme_host' => scheme_host}

      expect(Downloader.get_host_with_scheme("/cat.jpg", options)).to eq(scheme_host)
    end

    it "extracts the host and scheme via UrlHelper if options hash has no scheme_host option" do
      expect(Downloader.get_host_with_scheme("https://www.example.com/cat.jpg", {})). to eq(Addressable::URI.parse("https://www.example.com"))
    end

    it "extracts the host and scheme via UrlHelper if options hash is nil" do
      expect(Downloader.get_host_with_scheme("https://www.example.com/cat.jpg")). to eq(Addressable::URI.parse("https://www.example.com"))
    end
  end
end
