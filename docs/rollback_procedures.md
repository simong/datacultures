# Rollback procedures

When Data Cultures needs to be rolled back to a previous release, the following steps should be taken:

## 1. Stop Data Cultures

Stop the Data Cultures server.

## 2. Database migration rollback

All of the database migrations that were introduced between the current release and the release you want to roll back to should be reverted.

In order to do this, the following command should be run in for each of these database migrations (in descending order):

```
rake db:migrate:down VERSION=20150115105930
```

Where `VERSION` is the numerical part of the migration file (e.g. `20150115105930_add_canvas_student_actor_id_field_to_activities.rb`).

## 3. Clear Sidekiq queue

The Sidekiq Redis queue should be cleared:

```
redis-cli flushdb
```

## 4. Deploy previous release

The `BRANCH` environment variable should be set to the number of the release that is being deployed

```
BRANCH=1.1
```

Once this is set, the `deploy.sh` script should be run to deploy and start the specified Data Cultures release.
