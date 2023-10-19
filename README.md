# Setup

brew install overmind tmux

bundle install

yarn install

cp _.env .env

# Run the application (See Running)

bundle exec rake db:migrate

bundle exec rake db:test:prepare

bundle exec rake db:seed



# Running

overmind s -f Procfile.dev
