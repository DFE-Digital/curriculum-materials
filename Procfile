release: bin/rake db:migrate
web: bundle exec puma -p $PORT
worker: rake jobs:work
