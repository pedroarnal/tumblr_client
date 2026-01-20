# frozen_string_literal: true

require 'faraday'
require 'simple_oauth'

module Tumblr
  # OAuth 1.0 request signing middleware for Faraday.
  # Based on the faraday_middleware OAuth implementation pattern.
  class OAuth1Middleware < Faraday::Middleware
    AUTH_HEADER = 'Authorization'
    CONTENT_TYPE = 'Content-Type'
    TYPE_URLENCODED = 'application/x-www-form-urlencoded'

    def initialize(app, options = {})
      super(app)
      @options = options
    end

    def on_request(env)
      return if env.request_headers[AUTH_HEADER]

      env.request_headers[AUTH_HEADER] = oauth_header(env).to_s
    end

    private

    def oauth_header(env)
      SimpleOAuth::Header.new(
        env[:method],
        env[:url].to_s,
        signature_params(body_params(env)),
        @options
      )
    end

    def body_params(env)
      return {} unless include_body_params?(env)

      if env[:body].respond_to?(:to_str)
        Faraday::Utils.parse_nested_query(env[:body])
      else
        env[:body] || {}
      end
    end

    def include_body_params?(env)
      type = env[:request_headers][CONTENT_TYPE]
      !type || type == TYPE_URLENCODED
    end

    def signature_params(params)
      return params if params.empty?

      params.reject { |_k, v| v.respond_to?(:content_type) }
    end
  end
end

Faraday::Request.register_middleware(tumblr_oauth1: Tumblr::OAuth1Middleware)
