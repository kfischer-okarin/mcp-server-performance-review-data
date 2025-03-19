# frozen_string_literal: true

require 'octokit'

# GitHub client wrapper with minimal interface
class GitHubClient
  def initialize(access_token:)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def search_user_pull_requests(username:, organization:, start_date:, end_date:)
    query_filters = [
      'type:pr',
      "author:#{username}",
      "org:#{organization}",
      "created:#{start_date.strftime('%Y-%m-%d')}..#{end_date.strftime('%Y-%m-%d')}"
    ]
    query = query_filters.join(' AND ')
    result = @client.search_issues(query, per_page: 100, advanced_search: true)

    result.items.map do |pr|
      repository = pr[:repository_url].split('/').last
      {
        repository: repository,
        number: pr[:number],
        title: pr[:title],
        body: pr[:body],
        opened_at: pr[:created_at]
      }
    end
  end

  private

  def get_pull_request_details(pr_url, pr_number)
    repo = extract_repo_from_url(pr_url)
    @client.pull_request(repo, pr_number)
  end

  def extract_repo_from_url(url)
    # Extract org/repo from PR URL (e.g., https://github.com/org/repo/pull/123)
    url.match(%r{github\.com/(.+/.+)/pull/})[1]
  end
end
