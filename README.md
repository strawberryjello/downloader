# Downloader

[![Build Status](https://travis-ci.org/strawberryjello/downloader.svg?branch=master)](https://travis-ci.org/strawberryjello/downloader)
[![Coverage Status](https://coveralls.io/repos/github/strawberryjello/downloader/badge.svg?branch=master)](https://coveralls.io/github/strawberryjello/downloader?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/3daad91d43a6ba971351/maintainability)](https://codeclimate.com/github/strawberryjello/downloader/maintainability)

Automates file downloads. Supports batch downloading via newline-delimited link dump in a text file. Uses [http.rb](https://github.com/httprb/http) and [Addressable](https://github.com/sporkmonger/addressable) under the hood and [Thor](https://github.com/erikhuda/thor) for the CLI.

## Documentation

Check out the API documentation [here](https://rubydoc.info/github/strawberryjello/downloader/master).

If you cloned the repo, you can generate the API documentation yourself using YARD by running `yard doc` in the top-level directory; the documentation will appear in a `doc` directory.

## Installation

Add this line to your application's Gemfile:

```
gem "downloader", git: "https://github.com/strawberryjello/downloader.git"
```

This pulls from the master branch by default. You can also specify a version, eg:

```
gem "downloader", "0.3.1", git: "https://github.com/strawberryjello/downloader.git"
```

And then execute:

    $ bundle

Or install it yourself by cloning the repo and running the ff. in the top-level directory:

    $ rake install

## Usage

Download a single file:

```
Downloader.download(<URL>)
```

- Note: This will also return the original filename of the file you downloaded

Download multiple files whose URLs are saved to a text file:

```
Downloader.batch("/path/to/file", "/path/to/destination/directory")
```

Command-line options for `Downloader.batch` can be passed in via a hash, eg:

```
options = {:numbered_filenames => true}
Downloader.batch("/path/to/file", "/path/to/destination/directory", options)
```

### CLI

`Downloader.download` and `Downloader.batch` are available via CLI. You can also run the commands during development using `bundle exec exe/downloader <command> <options>`.

List the available commands:

    $ downloader

Download a single file:

    $ downloader download <url>

Download multiple files:

    $ downloader batch /path/to/file /path/to/destination/directory

#### CLI Options

`Downloader.batch` accepts the ff. options:

- `--numbered-filenames` - Rename files to be downloaded with numbers according to their order in the input file; file extensions, if any, will be retained

- `--scheme-host` - The scheme and host in one string, for files containing relative URLs

- `--scheme` - The scheme, for files containing scheme-less URLs

A `help` command is also available (Thor built-in) that will display the options for each command, eg:

    $ downloader help batch

## Tests and Documentation Coverage

Tests can be run locally using `rspec` or `rake` in the top-level directory.

To check documentation coverage (provided by [Inch](https://github.com/rrrene/inch)), run `inch` in the top-level directory.

## License

This project is licensed under the [MIT license](https://choosealicense.com/licenses/mit/).
