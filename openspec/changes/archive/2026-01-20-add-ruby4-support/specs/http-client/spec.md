# http-client Specification Delta

## ADDED Requirements

### Requirement: CGI Library Dependency for Ruby 4.0

The gem SHALL explicitly depend on `cgi ~> 0.4.2` to ensure `CGI.parse` is available for OAuth signature generation on Ruby 4.0+.

#### Scenario: Ruby 4.0 OAuth signing succeeds

- **WHEN** running on Ruby 4.0
- **AND** making an authenticated API request
- **THEN** the OAuth signature SHALL be generated successfully
- **AND** the request SHALL include a valid Authorization header

#### Scenario: CGI library available on Ruby 4.0

- **WHEN** the gem is installed on Ruby 4.0
- **THEN** `CGI.parse` SHALL be available via the explicit cgi gem dependency
- **AND** the `simple_oauth` library SHALL function correctly

## MODIFIED Requirements

### Requirement: No External OAuth Middleware Dependency

The HTTP client SHALL NOT depend on the `faraday-oauth1` gem and SHALL explicitly declare `cgi ~> 0.4.2` as a dependency to enable Ruby 4.0 compatibility.

#### Scenario: Ruby 4.0 bundle resolution

- **WHEN** running `bundle install` on Ruby 4.0
- **THEN** dependency resolution SHALL succeed without version conflicts
- **AND** no gem with `required_ruby_version < 4` SHALL be required
- **AND** the `cgi` gem version SHALL be >= 0.4.2 and < 0.5.0

#### Scenario: Ruby 3.4 bundle resolution

- **WHEN** running `bundle install` on Ruby 3.4
- **THEN** dependency resolution SHALL succeed without version conflicts
- **AND** the explicit `cgi` dependency SHALL not conflict with the bundled CGI library
