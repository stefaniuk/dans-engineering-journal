source "https://rubygems.org"

gem "jekyll", "~> 4.3.2"

# Required standard library gems for Ruby 3.4+
gem "csv"
gem "logger"
gem "base64"

# Plugins
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-last-modified-at"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", platforms: :windows

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", platforms: :jruby
