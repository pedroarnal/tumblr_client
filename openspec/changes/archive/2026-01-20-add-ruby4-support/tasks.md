# Tasks: Add Ruby 4.0 Support

## 1. Dependency Updates

- [x] 1.1 Add `cgi ~> 0.4.2` to gemspec runtime dependencies
- [x] 1.2 Update `required_ruby_version` to `'>= 3.4.0', '< 5.0'`

## 2. CI Configuration

- [x] 2.1 Add Ruby 4.0 to CI matrix in `.github/workflows/ci.yaml`

## 3. Validation

- [x] 3.1 Run `bundle install` on Ruby 3.4 and verify success
- [x] 3.2 Run `bundle install` on Ruby 4.0 and verify success
- [x] 3.3 Run full test suite on Ruby 3.4 (expect 118 pass)
- [x] 3.4 Run full test suite on Ruby 4.0 (expect 118 pass)

## 4. Documentation

- [x] 4.1 Update README.md to document Ruby 4.0 support
