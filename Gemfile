source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

if File.exists?('/home/rubyuser/SoftwareDev/git/datashift_audio_engine')
  gem 'datashift_audio_engine', path: '/home/rubyuser/SoftwareDev/git/datashift_audio_engine'
else
  gem 'datashift_audio_engine', git: 'https://github.com/autotelik/datashift_audio_engine.git'
end

group :test do
  gem 'byebug'
  gem 'capybara', '~> 2.13'

  # On Centos - QMAKE=/usr/lib64/qt5/bin/qmake gem install capybara-webkit
  #
  # TODO How to set in bundle - this dont seem to work :
  #   bundle config build.capybara-webkit  --with-opt-include=/usr/lib64/qt5/bin/qmake
  #
  gem 'capybara-webkit'

  gem 'database_cleaner', platforms: [:mri]

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'launchy'
  #gem 'listen'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'sqlite3', '~> 1.4'
end
