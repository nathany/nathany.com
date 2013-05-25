source 'http://rubygems.org'
ruby '2.0.0'

# gem 'nesta', github: 'gma/nesta'
gem 'nesta', github: 'nathany/nesta', branch: 'fork'
# gem 'nesta', :path => '../opensource/nesta'
gem 'redcarpet'
gem 'pygments.rb'

gem 'unicorn'
gem 'rack-contrib' # ResponseHeaders
gem 'rack-rewrite'
gem 'memcachier'
gem 'dalli'
gem 'rack-cache'
# gem 'oink'

# gem (RUBY_VERSION =~ /^1.9/) ? 'ruby-debug19': 'ruby-debug'

group :development do
  gem 'racksh'
  gem 'pry'
  # gem 'pry-debugger'
  gem 'foreman'
  gem 'mr-sparkle'
end

group :production do
  gem 'newrelic_rpm'
end
