source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in active_entry.gemspec.
gemspec

group :development do
  gem 'sqlite3'
  gem 'webrick', require: false
  gem 'yard', require: false
end

group :test do
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'simplecov-small-badge', github: "TFM-Agency/simplecov-small-badge", require: false
end

# To use a debugger
# gem 'byebug', group: [:development, :test]
