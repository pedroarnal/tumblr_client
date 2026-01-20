# http-client Specification

## Purpose
TBD - created by archiving change replace-faraday-oauth1-middleware. Update Purpose after archive.
## Requirements
### Requirement: OAuth1 Request Signing

The HTTP client SHALL sign all API requests using OAuth 1.0 authentication via a custom middleware that uses the `simple_oauth` library.

#### Scenario: Successful OAuth1 header generation

- **WHEN** a request is made to the Tumblr API with valid OAuth credentials
- **THEN** the request SHALL include an Authorization header with OAuth 1.0 signature
- **AND** the signature SHALL be generated using `SimpleOAuth::Header`

#### Scenario: Body parameters included in signature for URL-encoded content

- **WHEN** a POST request is made with `Content-Type: application/x-www-form-urlencoded`
- **THEN** the request body parameters SHALL be included in the OAuth signature calculation

#### Scenario: Body parameters excluded from signature for other content types

- **WHEN** a request is made with a Content-Type other than `application/x-www-form-urlencoded`
- **THEN** the request body parameters SHALL NOT be included in the OAuth signature calculation
- **AND** this behavior SHALL comply with RFC 5849 section 3.4.1.3.1

#### Scenario: Existing Authorization header is preserved

- **WHEN** a request already has an Authorization header set
- **THEN** the OAuth middleware SHALL NOT override the existing header

### Requirement: No External OAuth Middleware Dependency

The HTTP client SHALL NOT depend on the `faraday-oauth1` gem to enable Ruby 4.0 compatibility.

#### Scenario: Ruby 4.0 bundle resolution

- **WHEN** running `bundle install` on Ruby 4.0
- **THEN** dependency resolution SHALL succeed without version conflicts
- **AND** no gem with `required_ruby_version < 4` SHALL be required

### Requirement: Middleware Registration

The custom OAuth1 middleware SHALL be registered with Faraday under a namespaced identifier to avoid conflicts.

#### Scenario: Middleware available in Faraday stack

- **WHEN** configuring a Faraday connection
- **THEN** the middleware SHALL be available via `conn.request :tumblr_oauth1`
- **AND** the middleware SHALL accept OAuth credential options (consumer_key, consumer_secret, token, token_secret)

