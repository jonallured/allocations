require 'csv'
require 'octokit'

access_token = File.read('token.txt')
client = Octokit::Client.new(access_token: access_token)

# client.auto_paginate = true
options = {
  direction: :desc,
  per_page: 10, # per_page: 100,
  sort: :created,
  state: :all
}
all_pulls = client.pulls 'artsy/volt', options
# client.auto_paginate = false

authors = %w[ansor4 iskounen jonallured mdole oxaudo sepans starsirius]

relevant_pulls = all_pulls.select do |pull|
  author = pull.user.login
  authors.include? author
end

CSV.open('report.csv', 'w') do |file|
  rows = relevant_pulls.map do |pull|
    [
      pull.user.login,
      pull.created_at.to_date,
      pull.title,
      pull.number,
      pull.state
    ]
  end

  rows.each do |row|
    file << row
  end
end
