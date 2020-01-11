source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

group :development do
  gem "spring"
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

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'launchy'

  gem "mini_magick", ">= 4.9.4"

  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-sidekiq'

  gem 'shoulda-matchers', '~> 3.1'

  # TODO: remove once dev complete move to core gemspec
  if File.exists?('/home/rubyuser/SoftwareDev/git/datashift_audio_engine')
    gem 'datashift_audio_engine', path: '/home/rubyuser/SoftwareDev/git/datashift_audio_engine'
  else
    gem 'datashift_audio_engine', git: 'https://github.com/autotelik/datashift_audio_engine.git'
  end

  # TODO: remove once dev complete
  if File.exist?('../datashift')
    gem 'datashift', path: '../datashift'
  else
    gem 'datashift', git: 'https://github.com/autotelik/datashift.git'
  end

end
