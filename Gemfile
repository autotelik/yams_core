source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

if File.exists?('/home/rubyuser/SoftwareDev/git/yams_audio_engine')
  gem 'yams_audio', path: '/home/rubyuser/SoftwareDev/git/yams_audio_engine'
else
  gem 'yams_audio', git: 'https://github.com/autotelik/yams_audio_engine.git'
end

group :development do
  gem "spring"
end

group :test do

  gem 'byebug'
  gem 'capybara', '~> 2.13'

  gem 'database_cleaner'

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'launchy'

  gem "mini_magick", ">= 4.9.4"

  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-sidekiq'
  gem 'sqlite3'
  gem 'shoulda-matchers', '~> 3.1'

  # TODO: remove once dev complete
  if File.exist?('../datashift')
    gem 'datashift', path: '../datashift'
  else
    gem 'datashift', git: 'https://github.com/autotelik/datashift.git'
  end

end
