# frozen_string_literal: true

require "slack-ruby-client"
require_relative "slack_client/authentication"

# Slack client wrapper with minimal interface
class SlackClient
  class << self
    def authorized_client_for(client_id:, client_secret:, scope: "", user_scope: "")
      token = Authentication.authenticate(
        client_id: client_id,
        client_secret: client_secret,
        scope: scope,
        user_scope: user_scope
      )

      new(token: token)
    end
  end

  def initialize(token:)
    @client = Slack::Web::Client.new(token: token)
  end
end
