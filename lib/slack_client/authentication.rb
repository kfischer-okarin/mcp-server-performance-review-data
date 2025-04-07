# frozen_string_literal: true

require "uri"
require "slack-ruby-client"
require_relative "../temp_oauth_callback_server"

class SlackClient
  module Authentication
    module_function

    def authenticate(client_id:, client_secret:, scope: "", user_scope: "")
      oauth_callback_server = TempOAuthCallbackServer.new(
        path: "/oauth",
        port: 51111,
        webrick_config: {
          # Disabling/redirecting logs to avoid writing to stdout (used by MCP server)
          Logger: WEBrick::Log.new($stderr, WEBrick::Log::ERROR),
          AccessLog: []
        }
      )
      oauth_callback_server.start

      open_oauth_url(client_id: client_id, scope: scope, user_scope: user_scope, redirect_uri: oauth_callback_server.redirect_uri)

      code = oauth_callback_server.wait_for_code

      slack_client = Slack::Web::Client.new
      response = slack_client.oauth_v2_access(
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: oauth_callback_server.redirect_uri,
        grant_type: "authorization_code"
      )

      if response["ok"]
        token = response["access_token"]
        warn "Successfully authorized with Slack."
        token
      else
        raise "Failed to authorize with Slack. Error: #{response["error"]}"
      end
    end

    private

    def open_oauth_url(client_id:, redirect_uri:, scope: "", user_scope: "")
      query_params = {
        client_id: client_id,
        scope: scope,
        user_scope: user_scope,
        redirect_uri: redirect_uri
      }
      query_string = URI.encode_www_form(query_params)
      system "open https://slack.com/oauth/v2/authorize?#{query_string}"
    end
  end
end
