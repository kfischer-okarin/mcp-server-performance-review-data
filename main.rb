require 'dotenv/load'
require 'mcp'

require_relative 'lib/tools'

name 'performance_review_data'

tool 'list_user_pull_request_activity' do
  description <<~DESCRIPTION
    Retrieve the user's pull request activity (opened and reviewed) from GitHub
  DESCRIPTION

  argument :month,
           String,
           required: true,
           description: 'The month to retrieve the activity for (format: YYYY-MM)'

  call do |args|
    Tools::ListUserPullRequestActivity.new(
      month: args[:month]
    ).call
  end
end
