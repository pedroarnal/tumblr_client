# encoding: utf-8
require File.join(File.dirname(__FILE__), 'lib/tumblr/version')

Gem::Specification.new do |gem|
  gem.required_ruby_version = '>= 3.4.0'
  gem.add_dependency 'faraday', '~> 2.0'
  gem.add_dependency 'faraday-multipart'
  gem.add_dependency 'faraday-oauth1'
  gem.add_dependency 'json'
  gem.add_dependency 'simple_oauth'
  gem.add_dependency 'oauth'
  gem.add_dependency 'mime-types'
  gem.add_dependency 'base64'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'ostruct'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'stringio'
  gem.add_development_dependency 'irb'
  gem.authors = ['John Bunting', 'John Crepezzi']
  gem.description = %q{A Ruby wrapper for the Tumblr v2 API}
  gem.email = ['codingjester@gmail.com', 'john@crepezzi.com']
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files = `git ls-files`.split("\n")
  gem.homepage = "http://github.com/tumblr/tumblr_client"
  gem.license = "Apache"
  gem.name = "tumblr_client"
  gem.require_paths = ["lib"]
  gem.summary = %q{Tumblr API wrapper}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Tumblr::VERSION
end
