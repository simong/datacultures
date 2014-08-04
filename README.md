# datacultures

The Data Cultures running in Canvas

## setup

If your datacultures provider app is going to be other than just English, add a line to the config/locales/ yaml file for that language with the field 'app_name' -- see the [English locale file](config/locales/en.yml)

API keys are needed to access Canvas data.  They cannot be publicly published, so each datacultures instance plus canvas instance must have the correct API keys generated.

Do not use 'Developer API' keys, those have a lot of permissions.  Instead make users that will have very limited roles.

A key with the teacher's permissions will be needed for each course that uses the instance.

To create the proper API keys:

    For each course that will uses the backend,
        A. Log in as the instructor
        B. Go to the settings (follow the link in the upper right)
        C. At the bottom of the settings page, click "New Access Token"
        D. Follow the prompts, and don't place an expiration date (so the code won't stop working after that date)
        E. Save this generated token, it will be needed for the Canvas API calls.  It will be pasted for now in to the secrets.yml file (see below)
            
    5. Add to the config/secrets.yml (there is one statically in the repo, but the data should not be checked in) the entries as follows, for all environments (example given is for development).   Every running instance will need these keys, keeping them current will be part of the deploy process (or required setup for the instructor).

        test:
          secret_key_base: 60e5483ffefd8b18fb44f4fb8a285d007a1e79a583bbe9bfd1f18722ce204d2a179334b8cd31e629a6c3297906caa6d0ae89db82ce3bfe807d664d8e5f1a6c7d
          requests:
            base_url:  'http://localhost:3100/'
            real: false
            discussion_topic_id: "70239"
            course: "2390"
            api_keys:
              teacher:  "ThisShouldBeABigQuiteLongStringOfRandomSeemingLettersAndNumbers1"

In order to access the API keys, the same structure needs to be in every environment in which it is run (e.g.,  development, qa, or production).  If another method of configuration is desire, a Hash of the appropriate struct can be supplied in #perform method in the UpdateEngagementIndexWorker (located in app/workers/update_engagement_index_worker.rb).

To always mock, set the OS environment variable MOCK to 'always'.  To never mock, set MOCK to 'never'.

For 'course' above, fill in the course ID number from the instance that will be tested against.  For 'real', set the default (should mocks be use or real requests by default, if the MOCK environment variable is not set).  Set 'real' to true to make actual net work requests in specs, and false to mock them (both only if MOCK environment variable is not set).
Base URL is wherever your Canvas test server is located.

## Redis

The project requires Redis, which is used by Sidekiq.   Redis can be installed for OS/X (if you have homebrew installed) with:

```
$ brew install redis
```

Once Redis has been installed, start it to launch you project.  In a shell:

```
$ redis-server
```


## Sidekiq

For the jobs to be run, the sidekiq server needs to be started:

```
$ bundle exec sidekiq
```
The sidekiq server will start, and the workers defined to run by sidetiq will run.

## development

The following are all done from a Terminal (or iTerm2) window:

    $ bundle install
    $ sudo gem install zeus

    In your development environment, in one shell, start zeus:

    $ zeus start

    In another tab or window, start guard:

    $ guard

    Now, from other windows (or an edit tool such as RubyMine), change either a spec or the code it is covering, and it will be run in the guard window.

If you have changes to MOCK (or any other operating system environment variable for that matter), it will be necessary to restart zeus if it is in use.
