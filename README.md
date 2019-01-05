# Downloader

Automates file downloads. Supports batch downloading via newline-delimited link dump in a text file. Uses [http.rb](https://github.com/httprb/http) under the hood and [Thor](https://github.com/erikhuda/thor) for the CLI. Written for learning purposes.

## Documentation

See the wiki.

## Installation

_(NOTE: section generated by Bundler)_

**TODO: UPDATE THIS**

Add this line to your application's Gemfile:

```ruby
gem 'downloader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install downloader

## Usage

Download a single file:

```ruby
Downloader.download(<URL>, "/path/to/downloaded/file")
```

Download multiple files whose URLs are saved to a text file:

```ruby
Downloader.batch("/path/to/file", "/path/to/destination/directory")
```

### CLI

`Downloader.download` and `Downloader.batch` are available via CLI by running the `exe/downloader` executable.

List the available commands:

    $ bundle exec exe/downloader

Download a single file:

    $ bundle exec exe/downloader download <url> /path/to/downloaded/file

Download multiple files:

    $ bundle exec exe/downloader batch /path/to/file /path/to/destination/directory

## Development

_(NOTE: section generated by Bundler)_

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
