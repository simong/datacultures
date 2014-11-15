mkdir -p tmp/log
mkdir -p tmp/pids
bundle exec sidekiq -d -L tmp/log/sidekiq.log -P tmp/pids/sidekiq.pid
