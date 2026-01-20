# Design: Custom OAuth1 Middleware

## Context

The `faraday-oauth1` gem constrains Ruby to `< 4`, blocking Ruby 4.0 adoption. The gem is a thin wrapper around `simple_oauth` which has no version restrictions. We need to replace this dependency while maintaining identical OAuth1 signing behavior.

## Goals / Non-Goals

**Goals:**
- Remove `faraday-oauth1` dependency to enable Ruby 4.0 support
- Maintain 100% API compatibility with existing `Tumblr::Connection` usage
- Keep implementation minimal and well-tested

**Non-Goals:**
- Supporting OAuth2 (not used by Tumblr API v2)
- Adding new OAuth features beyond current usage
- Generalizing the middleware for other projects

## Decisions

### Decision: Implement as Faraday Middleware

**What:** Create `Tumblr::OAuth1Middleware` extending `Faraday::Middleware`

**Why:**
- Matches existing integration pattern
- Faraday's middleware architecture is stable
- Minimal code change to `connection.rb`

**Alternatives considered:**
1. Fork `faraday-oauth1` and update Ruby constraint - Adds maintenance burden
2. Use `oauthenticator` gem - Has `rack < 4.0` constraint, same problem
3. Wait for upstream fix - Uncertain timeline, blocks Ruby 4.0 adoption

### Decision: Base Implementation on faraday_middleware Pattern

**What:** Use the OAuth implementation pattern from the deprecated `faraday_middleware` gem

**Why:**
- Battle-tested in production across thousands of projects
- Clear, well-documented approach
- Handles edge cases (body params, content-type detection)

### Decision: Register Middleware with Faraday

**What:** Use `Faraday::Request.register_middleware` to register as `:tumblr_oauth1`

**Why:**
- Clean integration with Faraday's middleware stack
- Avoids naming conflicts with other OAuth middleware
- Explicit namespacing

## Implementation Pattern

```ruby
# Middleware signature (conceptual, not actual code)
class Tumblr::OAuth1Middleware < Faraday::Middleware
  def on_request(env)
    # 1. Check if signing is needed
    # 2. Build SimpleOAuth::Header with credentials
    # 3. Set Authorization header
  end
end
```

Key behaviors to preserve:
1. Sign requests using `SimpleOAuth::Header`
2. Include body params in signature for `application/x-www-form-urlencoded`
3. Skip body params for other content types (per RFC 5849 section 3.4.1.3.1)
4. Don't override existing Authorization headers

## Risks / Trade-offs

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Signing implementation differs from original | Low | High | Base on faraday_middleware source code |
| Missing edge case handling | Low | Medium | Comprehensive test coverage |
| Breaking API compatibility | Low | High | Test existing integration points |

## Migration Plan

1. Add new middleware file
2. Update gemspec (remove `faraday-oauth1`)
3. Update `connection.rb` to use new middleware
4. Run full test suite
5. No user-facing API changes required

**Rollback:** Revert gemspec and connection.rb changes

## Open Questions

None - implementation path is clear based on prior analysis.
