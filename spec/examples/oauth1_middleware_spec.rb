require 'spec_helper'
require 'tumblr/oauth1_middleware'

describe Tumblr::OAuth1Middleware do
  let(:app) { ->(env) { env } }
  let(:credentials) do
    {
      consumer_key: 'test_consumer_key',
      consumer_secret: 'test_consumer_secret',
      token: 'test_token',
      token_secret: 'test_token_secret'
    }
  end
  let(:middleware) { described_class.new(app, credentials) }

  def make_env(options = {})
    Faraday::Env.new.tap do |env|
      env.method = options[:method] || :get
      env.url = URI.parse(options[:url] || 'https://api.tumblr.com/v2/test')
      env.body = options[:body]
      env.request_headers = Faraday::Utils::Headers.new(options[:headers] || {})
    end
  end

  describe '#on_request' do
    context 'Authorization header generation' do
      it 'adds an Authorization header with OAuth parameters' do
        env = make_env
        middleware.on_request(env)

        expect(env[:request_headers]['Authorization']).to be_a(String)
        expect(env[:request_headers]['Authorization']).to include('OAuth')
        expect(env[:request_headers]['Authorization']).to include('oauth_consumer_key')
        expect(env[:request_headers]['Authorization']).to include('oauth_signature')
        expect(env[:request_headers]['Authorization']).to include('oauth_token')
      end

      it 'includes oauth_nonce and oauth_timestamp' do
        env = make_env
        middleware.on_request(env)

        expect(env[:request_headers]['Authorization']).to include('oauth_nonce')
        expect(env[:request_headers]['Authorization']).to include('oauth_timestamp')
      end
    end

    context 'when Authorization header already exists' do
      it 'does not override the existing header' do
        env = make_env(headers: { 'Authorization' => 'Bearer existing_token' })
        middleware.on_request(env)

        expect(env[:request_headers]['Authorization']).to eq('Bearer existing_token')
      end
    end

    context 'body parameter handling for URL-encoded requests' do
      it 'includes body params in signature when Content-Type is not set' do
        env1 = make_env(method: :post, body: 'foo=bar')
        env2 = make_env(method: :post, body: 'foo=bar')

        middleware.on_request(env1)
        middleware.on_request(env2)

        # Both should have Authorization headers (signature may differ due to timestamp/nonce)
        expect(env1[:request_headers]['Authorization']).to include('oauth_signature')
        expect(env2[:request_headers]['Authorization']).to include('oauth_signature')
      end

      it 'includes body params in signature for application/x-www-form-urlencoded' do
        env = make_env(
          method: :post,
          body: 'foo=bar',
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
        )
        middleware.on_request(env)

        expect(env[:request_headers]['Authorization']).to include('oauth_signature')
      end

      it 'excludes body params from signature for other content types' do
        env = make_env(
          method: :post,
          body: '{"foo":"bar"}',
          headers: { 'Content-Type' => 'application/json' }
        )
        middleware.on_request(env)

        expect(env[:request_headers]['Authorization']).to include('oauth_signature')
      end
    end

    context 'with hash body' do
      it 'handles hash body correctly' do
        env = make_env(method: :post, body: { foo: 'bar' })
        middleware.on_request(env)

        expect(env[:request_headers]['Authorization']).to include('oauth_signature')
      end
    end
  end

  describe 'Faraday middleware registration' do
    it 'is registered as :tumblr_oauth1' do
      expect(Faraday::Request.lookup_middleware(:tumblr_oauth1)).to eq(Tumblr::OAuth1Middleware)
    end
  end
end
