# frozen_string_literal: true

require "webrick"

class TempOAuthCallbackServer
  def initialize(path:, port:, webrick_config: {})
    @path = path
    @port = port
    @code = nil

    @webrick_config = {Port: @port}.merge(webrick_config)
  end

  def redirect_uri
    "http://localhost:#{@port}#{@path}"
  end

  def start
    @server = WEBrick::HTTPServer.new(@webrick_config)

    @server.mount_proc @path do |req, res|
      @code = req.query["code"]
      res.body = "Authorization successful! You can close this window."
      @server.shutdown
    end

    @server_thread = Thread.new do
      @server.logger.info "Starting OAuth callback server on port #{@port}..."
      @server.logger.info "Redirect URI: #{redirect_uri}"
      @server.logger.info "Waiting for authorization code..."
      @server.start
    end
  end

  def wait_for_code
    @server_thread.join
    @server.logger.info "Received authorization code: #{@code}" if @code
    @code
  end
end
