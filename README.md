# Downloader

[![Build Status](https://travis-ci.org/strawberryjello/downloader.svg?branch=master)](https://travis-ci.org/strawberryjello/downloader)
[![Coverage Status](https://coveralls.io/repos/github/strawberryjello/downloader/badge.svg?branch=master)](https://coveralls.io/github/strawberryjello/downloader?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/3daad91d43a6ba971351/maintainability)](https://codeclimate.com/github/strawberryjello/downloader/maintainability)

Automates file downloads. Supports batch downloading via newline-delimited link dump in a text file. Uses [http.rb](https://github.com/httprb/http) and [Addressable](https://github.com/sporkmonger/addressable) under the hood and [Thor](https://github.com/erikhuda/thor) for the CLI. Written for learning purposes.

## Installation

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
Downloader.download(<URL>)
```
- Note: This will also return the original filename of the file you downloaded

Download multiple files whose URLs are saved to a text file:

```ruby
Downloader.batch("/path/to/file", "/path/to/destination/directory")
```

Command-line options for `Downloader.batch` can be passed in via a hash, eg:

```ruby
options = {:numbered_files => true}
Downloader.batch("/path/to/file", "/path/to/destination/directory", options)
```

### CLI

`Downloader.download` and `Downloader.batch` are available via CLI by running the `exe/downloader` executable.

List the available commands:

    $ bundle exec exe/downloader

Download a single file:

    $ bundle exec exe/downloader download <url>

Download multiple files:

    $ bundle exec exe/downloader batch /path/to/file /path/to/destination/directory

#### CLI Options

`Downloader.batch` accepts the ff. options:

- `--numbered-filenames` - Rename files to be downloaded with numbers according to their order in the input file; file extensions, if any, will be retained

- `--scheme-host` - The scheme and host in one string, for files containing relative URLs

- `--scheme` - The scheme, for files containing scheme-less URLs

A `help` command is also available (Thor built-in) that will display the options for each command, eg:

    $ bundle exec exe/downloader help batch
