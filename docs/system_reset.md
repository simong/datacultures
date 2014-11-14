## System Full Reset

To reset the system, shut everything down, clear all the data in the Postgres and in Redis, and then restart everything.

### Clearing:

* Stop Sending jobs to Sidekiq:

```shell
    clockworkd -c scripts/clock.rb --pid-dir=tmp/pids stop
```

* Stop Sidekiq:

```shell
    sidekiqctl stop tmp/pids/sidekiq.pid
```

* Stop apache (this will depend on your setup):

```shell
    apachectl -k stop
```

* Clear out Redis:
   (This is a dangerous but thorough way to do this.  Be sure your Redis instance is not serving other purposes before doing this)

```shell
    redis-cli
```

In the redis shell:

```shell
    FLUSHDB
```

* Clear out the Postgres Database:
  (You might want to omit the "PointsConfiguration" data from deletion below.)

```shell
    rails c
```

In the rails console:

```ruby
    [Activity, Assignment, Attachment, Comment, MediaUrl, PointsConfiguration, Student, View].each do |model| 
      model.delete_all
    end
```


### Restarting:

* Restart apache (again, this depends on your setup)

```shell
    apachectl -k start
```

* Reseed the data (if you didn't omit PointsConfiguration above.  But don't worry it will not overwrite any existing records):

```shell
    rake db:seed
```

* Restart sidekiq:

```shell
    mkdir -p /tmp/log
    mkdir -p /tmp/pids
    bundle exec sidekiq -d -L tmp/log/sidekiq.log -P tmp/pids/sidekiq.pid
```

* Restart clockworkd:

```shell
    clockworkd -c scripts/clock.rb --log-dir=tmp/log --pid-dir=tmp/pids -l start
```
