# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.2] - 2020-05-18
### Changed
- Add `locawebcommon` info to the project.

## [0.4.1] - 2020-03-04
### Fixed
- Fix character issue in the yapay transaction creation.

### Changed
- Update elixir version to [1.10](https://elixir-lang.org/blog/2020/01/27/elixir-v1-10-0-released/).

## [0.4.0] - 2019-12-23
### Added
- Add `Transaction.get(token_account, token_transaction)` to get a transaction.

### Removed
- Remove `Transaction.create` with the `Yapay` struct.

## [0.3.0] - 2019-12-03
### Added
- Add support for the attributes: `shipping_price` and `shipping_type`.

## [0.2.0] - 2019-11-18
### Added
- Add support for the attributes: `reseller_token` and `url_notification`.
- Add support for `ibrowse` options and `timeout`.

### Fixed
- Request error handling.

### Changed
- Change function `Yapay.create_transaction/2` to support: `Yapay struct` or `map`.

## [0.1.0] - 2019-08-26
### Added
- Integration with Yapay's transaction API.

## [0.0.1] - 2019-08-13
### Added
- Bootstrap application.

[Unreleased]: https://code.locaweb.com.br/locawebcommon/yapay/compare/master...v0.4.2
[0.4.2]: https://code.locaweb.com.br/locawebcommon/yapay/compare/v0.4.1...v0.4.2
[0.4.1]: https://code.locaweb.com.br/locawebcommon/yapay/compare/v0.4.0...v0.4.1
[0.4.0]: https://code.locaweb.com.br/locawebcommon/yapay/compare/v0.3.0...v0.4.0
[0.3.0]: https://code.locaweb.com.br/locawebcommon/yapay/compare/v0.2.0...v0.3.0
[0.2.0]: https://code.locaweb.com.br/locawebcommon/yapay/compare/v0.1.0...v0.2.0
[0.1.0]: https://code.locaweb.com.br/locawebcommon/yapay/compare/v0.0.1...v0.1.0
[0.0.1]: https://code.locaweb.com.br/locawebcommon/yapay/-/tags/v0.0.1
