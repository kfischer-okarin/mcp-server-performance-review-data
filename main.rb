# Ensure being in the same directory as the main.rb file so bundler can find the Gemfile
Dir.chdir(File.dirname(__FILE__))
require 'bundler/setup'

require_relative 'lib/parse_args'
Dotenv.require_keys('GITHUB_PERSONAL_ACCESS_TOKEN')

require 'mcp'

require_relative 'lib/tools'

name 'performance-review-mcp-server'

tool 'list_user_pull_request_activity' do
  description "Retrieve the user's pull request activity (opened and reviewed) from GitHub"
  argument :username,
           String,
           required: true,
           description: 'The GitHub username to retrieve the activity for'
  argument :month,
           String,
           required: true,
           description: 'The month to retrieve the activity for (format: YYYY-MM)'
  argument :organization,
           String,
           required: true,
           description: 'The GitHub organization to retrieve the activity for'

  call do |args|
    Tools::ListUserPullRequestActivity.new(
      username: args[:username],
      month: args[:month],
      organization: args[:organization]
    ).call
  end
end
