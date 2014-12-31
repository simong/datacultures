# DataCultures Components

## [DataCultures](/) application.   This is the Rails application itself.

## [Postgres](http://http://www.postgresql.org/).  Postgres is an open source, ACID, relational database.
DataCultures uses Postgres, configured in the usual config/database.yml file but with parameters loaded from the configuration file (../config/.env_conf.yml).  There is a task to clean out postgres (of tables other than the points_configuration, which should usually not be cleared):
```shell
    thor clean:db
```

## [Redis](http://redis.io/) is an in-memory key-value cache and store (database).
Sidekiq uses Redis to queue and manage worker processes.  Sidekiq jobs in this application are all stored in the 'queue:default' key.  Find the process ID of any running sidekiq tasks with:
```shell
    pgrep -f redis
```

## [Sidekiq](http://sidekiq.org/) is a background processing system. Workers are used to query Canvas for changes (Discussion participation and assignment submissions) to be added to DataCultures
If code is changed or deployed, not only must the web server restart to pick up changes (if not in development mode), but Sidekiq must be restarted. When Sidekiq is restarted, the old queued values must be removed from Redis (or else when it restarts, sidekiq will pick up where it left off, processing data with old values).  Sidekiq logging has been turned down to WARN level in production environments.  Sidekiq maintains a file with current PID in tmp/pids/sidekiq.pid, but this can get out of sync. There is a start script for sidekiq:
```shell
    [scripts/start_sidekiq.sh](../scripts/start_sidekiq.sh)
```

Find the process ID of a running instance or running instances instances with:
```shell
    pgrep -f sidekiq
```

## [Clockwork](https://github.com/tomykaira/clockwork) is a "clock process to replace cron."
The clockworkd piece of clockwork daemonizes clockwork, and is used to schedule sidekiq jobs.  The [scripts/clock.rb](../scripts/clock.rb) file configures clockworkd.   There is a script to start clockworkd:
```shell
    [scripts/start_clockworkd.sh](../scripts/start_clockworkd.sh)
```

Clockworkd maintains a file with current PID in tmp/pids/clockworkd.clock.pid, but this can get out of sync.  Find the process ID of a running instance or running instances instances with:
```shell
    pgrep -f clockworkd
```

Both Clockworkd and Sidekiq can be started at the same time with:
```shell
    foreman start
```

Foreman uses the [Procfile](../Procfile) as a recipe for what to do.

