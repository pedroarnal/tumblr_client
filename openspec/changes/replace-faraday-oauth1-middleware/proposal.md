# Change: Replace faraday-oauth1 with Custom OAuth1 Middleware

## Why

The `faraday-oauth1` gem has an explicit Ruby version constraint (`>= 2.6, < 4`) that blocks this gem from being compatible with Ruby 4.0. Since `simple_oauth` (which `faraday-oauth1` uses internally) has no Ruby version restrictions, we can implement a lightweight custom middleware to eliminate this dependency blocker.

## What Changes

- **BREAKING**: Remove `faraday-oauth1` gem dependency from gemspec
- Add new `Tumblr::OAuth1Middleware` class (~50 lines) using `simple_oauth` directly
- Update `Tumblr::Connection` to use the custom middleware instead of `faraday-oauth1`
- Add unit tests for the new middleware

## Impact

- Affected specs: `http-client` (new capability spec)
- Affected code:
  - `tumblr_client.gemspec` - remove `faraday-oauth1` dependency
  - `lib/tumblr/connection.rb` - change middleware registration
  - `lib/tumblr/oauth1_middleware.rb` - new file
  - `spec/examples/oauth1_middleware_spec.rb` - new test file

## Benefits

1. Enables Ruby 4.0 compatibility
2. Reduces external dependency count
3. Full control over OAuth1 signing implementation
4. `simple_oauth` has no Ruby version restrictions (`>= 0`)

## Risks

- Custom implementation must correctly handle all OAuth1 signing scenarios
- Mitigation: Implementation based on proven `faraday_middleware` OAuth code pattern
