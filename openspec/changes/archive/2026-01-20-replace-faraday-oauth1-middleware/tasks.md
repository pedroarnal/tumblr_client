# Tasks: Replace faraday-oauth1 with Custom Middleware

## 1. Implement Custom Middleware

- [x] 1.1 Create `lib/tumblr/oauth1_middleware.rb` with OAuth1 signing logic
- [x] 1.2 Register middleware with Faraday as `:tumblr_oauth1`

## 2. Update Dependencies

- [x] 2.1 Remove `faraday-oauth1` from `tumblr_client.gemspec`
- [x] 2.2 Verify `simple_oauth` is already listed as a dependency (it is)

## 3. Update Connection Module

- [x] 3.1 Update `lib/tumblr/connection.rb` to require the new middleware
- [x] 3.2 Change middleware registration from `:oauth1` to `:tumblr_oauth1`

## 4. Add Tests

- [x] 4.1 Create `spec/examples/oauth1_middleware_spec.rb`
- [x] 4.2 Test Authorization header generation
- [x] 4.3 Test body parameter handling for URL-encoded requests
- [x] 4.4 Test skipping signature when Authorization header already set

## 5. Validation

- [x] 5.1 Run existing test suite to verify no regressions (118 examples, 0 failures)
- [x] 5.2 Verify `bundle install` succeeds without `faraday-oauth1`
- [x] 5.3 Test manual API call to Tumblr (if credentials available)
