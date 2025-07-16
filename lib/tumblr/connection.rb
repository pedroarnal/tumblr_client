# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require 'faraday/oauth1'

module Tumblr
  module Connection

    def connection(options = {})
      options = options.clone

      Faraday.new(url: "#{api_scheme}://#{api_host}/") do |conn|
        conn.request :oauth1, 'header', **credentials
        conn.request :multipart
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.use Faraday::Response::RaiseError
        conn.adapter Faraday.default_adapter
        conn.headers.update(
          {
            "accept" => 'application/json',
            "user_agent" => "tumblr_client/#{Tumblr::VERSION}"
          }.merge(options)
        )
      end
    end

  end
end
