require 'dotenv/load'
require 'mcp'

require_relative 'lib/tools'

name 'performance_review_data'

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
