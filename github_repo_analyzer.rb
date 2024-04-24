require 'httparty'
require 'json'

def fetch_repositories(username)
  url = "https://api.github.com/users/#{username}/repos"

  response = HTTParty.get(url)

  if response.code == 200
    JSON.parse(response.body)
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

def analyze_repositories(repositories)
  return nil if repositories.nil? || repositories.empty?

  most_starred_repo = repositories.max_by { |repo| repo['stargazers_count'] }

  {
    name: most_starred_repo['name'],
    description: most_starred_repo['description'],
    stars: most_starred_repo['stargazers_count'],
    url: most_starred_repo['html_url']
  }
end

def display_result(repo_info)
  return puts "No public repositories found for this user." if repo_info.nil?

  puts "Most Starred Repository:"
  puts "Name: #{repo_info[:name]}"
  puts "Description: #{repo_info[:description]}"
  puts "Stars: #{repo_info[:stars]}"
  puts "URL: #{repo_info[:url]}"
end

if ARGV.empty?
  puts "Usage: ruby github_repo_analyzer.rb <username>"
  exit
end

username = ARGV[0]
repositories = fetch_repositories(username)

if repositories
  most_starred_repo_info = analyze_repositories(repositories)
  display_result(most_starred_repo_info)
end
