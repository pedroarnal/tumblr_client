# Change: Add Ruby 4.0 Support

## Why

Ruby 4.0 was released on December 25, 2025. The gem currently requires Ruby >= 3.4.0 but fails on Ruby 4.0 due to the removal of the CGI library from the standard library. Both `simple_oauth` and `oauth` dependencies use `CGI.parse`, which is no longer available in Ruby 4.

## What Changes

- Add explicit `cgi ~> 0.4.2` runtime dependency (last version containing `CGI.parse`)
- Update `required_ruby_version` to support Ruby 4.0
- Add Ruby 4.0 to CI test matrix
- Update existing http-client spec to document Ruby 4.0 compatibility requirement

## Impact

- Affected specs: `http-client`
- Affected code:
  - `tumblr_client.gemspec` - dependency and version constraints
  - `.github/workflows/ci.yaml` - CI matrix

## Background

### Root Cause Analysis

Ruby 4.0 removed the CGI library from the standard library. The `CGI.parse` method, used for URL query parsing, is no longer bundled by default.

| Gem | Version | Issue |
|-----|---------|-------|
| simple_oauth | 0.3.1 | Uses `CGI.parse` in `lib/simple_oauth/header.rb:121` |
| oauth | 1.1.3 | Uses `CGI.parse` in `lib/oauth/request_proxy/net_http.rb:38` |

### Solution Discovery

The `cgi` gem versions follow this pattern:
- `cgi` 0.4.x - Contains `CGI.parse`
- `cgi` 0.5.x - Removed `CGI.parse` (intentional deprecation)

By pinning `cgi ~> 0.4.2`, we get versions `>= 0.4.2` and `< 0.5.0`, which include `CGI.parse`.

### Verification Results

| Environment | Tests |
|-------------|-------|
| Ruby 3.4.8 (no changes) | 118 pass |
| Ruby 4.0.1 (no changes) | 6 fail |
| Ruby 4.0.1 + `cgi ~> 0.4.2` | 118 pass |

## Alternatives Considered

1. **Fork simple_oauth and replace `CGI.parse` with `URI.decode_www_form`** - Higher maintenance burden, requires maintaining a fork
2. **Implement OAuth signing internally** - Significant code increase, more maintenance
3. **Wait for upstream fixes** - `simple_oauth` unmaintained since 2014, `oauth` has no Ruby 4 fix yet

The chosen approach (pinning `cgi ~> 0.4.2`) is the lowest-risk path with minimal code changes.

## Long-term Considerations

The `cgi ~> 0.4.2` constraint is a stopgap. If the cgi 0.4.x line stops receiving security updates or becomes incompatible with future Ruby versions, alternatives will need to be revisited.
