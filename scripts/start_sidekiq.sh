mkdir -p tmp/log
mkdir -p tmp/pids
bundle exec sidekiq -d -c 10 -L tmp/log/sidekiq.log -P tmp/pids/sidekiq.pid
