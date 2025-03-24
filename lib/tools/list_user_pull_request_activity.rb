# frozen_string_literal: true

require 'time'
require 'rexml/document'

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

    def initialize(start_date:, end_date:)
      @start_date = Time.parse(start_date)
      @end_date = Time.parse(end_date)
    end

    def call
      pull_requests = fetch_pull_requests(@start_date, @end_date)
      generate_xml_output(pull_requests)
    end

    private

    def fetch_pull_requests(start_date, end_date)
      self.class.github_client.search_user_pull_requests(
        username: self.class.username,
        organization: self.class.organization,
        start_date: start_date,
        end_date: end_date
      )
    end

    def generate_xml_output(pull_requests)
      doc = REXML::Document.new
      doc << REXML::XMLDecl.new('1.0', 'UTF-8')

      root = REXML::Element.new('pull-request-activity')
      root.add_attribute('start_date', @start_date.strftime('%Y-%m-%d'))
      root.add_attribute('end_date', @end_date.strftime('%Y-%m-%d'))
      doc.add_element(root)

      pull_requests.each do |pr|
        opened_at_local = pr[:opened_at].getlocal.iso8601
        description = truncate_text(pr[:body], 100)

        pr_element = REXML::Element.new('pr')
        pr_element.add_attribute('repository', pr[:repository])
        pr_element.add_attribute('number', pr[:number].to_s)
        pr_element.add_attribute('opened_at', opened_at_local)

        title = REXML::Element.new('title')
        title.text = pr[:title]
        pr_element.add_element(title)

        desc = REXML::Element.new('description-preview')
        desc.text = description
        pr_element.add_element(desc)

        root.add_element(pr_element)
      end

      formatter = REXML::Formatters::Pretty.new(2)
      formatter.compact = true
      output = String.new
      formatter.write(doc, output)
      output
    end

    def truncate_text(text, max_length)
      return '' if text.nil? || text.empty?

      if text.length <= max_length
        text
      else
        text[0...max_length] + '...'
      end
    end
  end
end
