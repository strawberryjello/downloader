# Changelog
All notable changes to this project will be documented in this file.

The format is based partly on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

NOTE: The changelogs for each release are included in the message of the corresponding annotated tag.

## [0.3.2] - 2019-07-02
- README and in-line documentation updates
- Specified MIT license in gemspec
- Re-enabled Bundler's built-in Rake tasks
- Removed filename regex from UrlHelper, used Addressable::URI#basename instead

## [0.3.1] - 2019-06-21
- Setup for Travis CI and Coveralls
- Added MIT license file
- Added CHANGELOG file
- README updates, including badges for Travis CI, Coveralls, and Code Climate

## [0.3.0] - 2019-03-29
- Add --scheme option to Downloader.batch
- Update "missing scheme" error message

## [0.2.6] - 2019-02-02
- Bugfix: Can't handle filenames with commas

## [0.2.5] - 2019-01-20
- Bugfix: Can't handle filenames with exclamation points

## [0.2.4] - 2019-01-19
- Handle URLs with unescaped Unicode
- Update exit calls: add a nonzero status code
- Downloader.batch option --numbered-filenames typo fix

## [0.2.3] - 2019-01-18
- Redirect handling via http.rb

## [0.2.2] - 2019-01-16
- Refactoring: move logger initialization into new Loggable module

## [0.2.1] - 2019-01-13
- Download.batch: handle relative refs

## [0.2.0] - 2019-01-13
- Download.batch: option for renaming files
- Bugfix: Download.batch can't handle files with empty lines
- Bugfix: Download.batch can't handle a nil options hash

## [0.1.1] - 2019-01-10
- Bugfix: Downloader.batch can't handle files containing multiple lines
- Downloader.download now returns the filename of the downloaded file

## [0.1.0] - 2019-01-08
- Initial version of gem based on the original script I wrote a while back
- Refactored code to use Ruby's URI and Logger classes (stdlib) and custom error classes
- Added CLI using Thor based on the example in the Bundler gem-building guide
- Added RSpec for tests; only helper classes are tested currently

[0.3.2]: https://github.com/strawberryjello/downloader/releases/tag/v0.3.2
[0.3.1]: https://github.com/strawberryjello/downloader/releases/tag/v0.3.1
[0.3.0]: https://github.com/strawberryjello/downloader/releases/tag/v0.3.0
[0.2.6]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.6
[0.2.5]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.5
[0.2.4]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.4
[0.2.3]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.3
[0.2.2]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.2
[0.2.1]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.1
[0.2.0]: https://github.com/strawberryjello/downloader/releases/tag/v0.2.0
[0.1.1]: https://github.com/strawberryjello/downloader/releases/tag/v0.1.1
[0.1.0]: https://github.com/strawberryjello/downloader/releases/tag/v0.1.0
