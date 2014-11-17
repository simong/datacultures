mkdir -p tmp/log
mkdir -p tmp/pids
clockworkd -c scripts/clock.rb --log-dir=tmp/log --pid-dir=tmp/pids -l start
