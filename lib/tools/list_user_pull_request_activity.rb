module Tools
  class ListUserPullRequestActivity
    def initialize(username:, month:, organization:)
      @username = username
      @month = month
      @organization = organization
    end
  end
end
