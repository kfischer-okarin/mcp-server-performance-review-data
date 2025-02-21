# Ensure being in the same directory as the main.rb file so bundler can find the Gemfile
Dir.chdir(File.dirname(__FILE__))
require 'bundler/setup'

require_relative 'lib/parse_args'

require 'mcp'

name 'performance-review-mcp-server'
