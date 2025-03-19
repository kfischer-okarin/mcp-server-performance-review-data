# frozen_string_literal: true

require 'time'

require_relative '../github_client'

module Tools
  class ListUserPullRequestActivity
    class << self
      attr_reader :username, :organization, :personal_access_token, :github_client
    end

    @username = ENV["GITHUB_USERNAME"]
    $stderr.puts "Environment Variable GITHUB_USERNAME is not set" if @username.nil?
    @organization = ENV["GITHUB_ORGANIZATION"]
    $stderr.puts "Environment Variable GITHUB_ORGANIZATION is not set" if @organization.nil?
    @personal_access_token = ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]
    $stderr.puts "Environment Variable GITHUB_PERSONAL_ACCESS_TOKEN is not set" if @personal_access_token.nil?

    # Initialize the GitHub client once as a class variable
    @github_client = GitHubClient.new(access_token: @personal_access_token)

    def initialize(month:)
      @month = month
    end

    def call
      start_date, end_date = calculate_date_range
      pull_requests = fetch_pull_requests(start_date, end_date)

      generate_xml_output(pull_requests)
    end

    private

    def calculate_date_range
      year, month = @month.split('-').map(&:to_i)
      start_date = Time.new(year, month, 1)

      # Calculate end date (last day of the month)
      next_month = month == 12 ? 1 : month + 1
      next_year = month == 12 ? year + 1 : year
      end_date = Time.new(next_year, next_month, 1) - 1

      [start_date, end_date]
    end

    def fetch_pull_requests(start_date, end_date)
      self.class.github_client.search_user_pull_requests(
        username: self.class.username,
        organization: self.class.organization,
        start_date: start_date,
        end_date: end_date
      )
    end

    def generate_xml_output(pull_requests)
      xml = []
      xml << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      xml << "<pull-request-activity month=\"#{@month}\">"

      pull_requests.each do |pr|
        opened_at_local = pr[:opened_at].getlocal.iso8601
        description = truncate_text(pr[:body], 100)

        xml << "  <pr repository=\"#{pr[:repository]}\" number=\"#{pr[:number]}\" opened_at=\"#{opened_at_local}\">"
        xml << "    <title>#{escape_xml(pr[:title])}</title>"
        xml << "    <description-preview>#{escape_xml(description)}</description-preview>"
        xml << "  </pr>"
      end

      xml << "</pull-request-activity>"
      xml.join("\n")
    end

    def truncate_text(text, max_length)
      return '' if text.nil? || text.empty?

      if text.length <= max_length
        text
      else
        text[0...max_length] + '...'
      end
    end

    def escape_xml(text)
      return '' if text.nil?

      text.gsub(/[&<>"]/) do |c|
        case c
        when '&' then '&amp;'
        when '<' then '&lt;'
        when '>' then '&gt;'
        when '"' then '&quot;'
        end
      end
    end
  end
end
