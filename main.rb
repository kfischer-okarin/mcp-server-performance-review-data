require 'dotenv/load'
require 'mcp'

require_relative 'lib/tools'

name 'performance_review_data'

tool 'list_user_pull_request_activity' do
  description <<~DESCRIPTION
    Retrieve the user's opened pull requests from GitHub within a specified date range.

    Use this to get an overview of the user's development activity within a specific time frame.
  DESCRIPTION

  argument :start_date,
           String,
           required: true,
           description: 'The start date for the activity (format: YYYY-MM-DD)'

  argument :end_date,
           String,
           required: true,
           description: 'The end date for the activity (format: YYYY-MM-DD)'

  call do |args|
    Tools::ListUserPullRequestActivity.new(
      start_date: args[:start_date],
      end_date: args[:end_date]
    ).call
  end
end
