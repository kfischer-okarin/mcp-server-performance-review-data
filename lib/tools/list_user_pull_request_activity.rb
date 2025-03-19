module Tools
  class ListUserPullRequestActivity
    class << self
      attr_reader :username, :organization, :personal_access_token

      @username = ENV["GITHUB_USERNAME"]
      $stderr.puts "Environment Variable GITHUB_USERNAME is not set" if @username.nil?
      @organization = ENV["GITHUB_ORGANIZATION"]
      $stderr.puts "Environment Variable GITHUB_ORGANIZATION is not set" if @organization.nil?
      @personal_access_token = ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]
      $stderr.puts "Environment Variable GITHUB_PERSONAL_ACCESS_TOKEN is not set" if @personal_access_token.nil?
    end

    def initialize(month:)
      @month = month
    end
  end
end
