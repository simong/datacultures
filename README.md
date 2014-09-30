# Data Cultures

The Data Cultures LTI provider application running in Canvas

[![Dependency Status](https://img.shields.io/gemnasium/ets-berkeley-edu/datacultures.svg)](https://gemnasium.com/ets-berkeley-edu/datacultures) [![Code Climate](https://img.shields.io/codeclimate/github/ets-berkeley-edu/datacultures.svg)](https://codeclimate.com/github/ets-berkeley-edu/datacultures)
* Master Build: [![Build Status](https://api.travis-ci.org/ets-berkeley-edu/datacultures.svg?branch=master)](https://travis-ci.org/ets-berkeley-edu/datacultures)

## Initial Setup

Instructions are for a Apple OS/X.   The instructions are written for installation into the user's home directory ("~"), if another directory is desire, substitue it below for "~" in the bash block.  Commands are to be run from a terminal window (e.g., a bash shell in Terminal or iTerm), or in a similar shell in Linux or FreeBSD.

### Obtain the code and configure the application

Clone the code from github and copy the sample configuration file.  If the config directory already exists, be sure it is readable:

```shell
   ~ $ git clone https://github.com/ets-berkeley-edu/datacultures.git
   ~ $ mkdir -p config
   ~ $ cp datacultures/config/.env_conf.yml.example config/.env_conf.yml
```

The LTI tokens that are used to communicate between the Data Cultures LTI provider and the Canvas consumer must be generated. There is a Thor task for this:

```shell
~ $ cd datacultures
~/datacultures $ thor keys:lti_new
```

The new keys will print out.  In the browser with Canvas open, and while logged in as a teacher, go to the course, select the settings tab on the left, click the Applications tab in the middle of the screen, click on Add application.

In the dialog that appears, change the configuration type drop-down to 'By URL'.  For the URL field, you must list the location where Canvas can access DataCultures, and the port, e.g., 'http://learn.berkeley.edu:5000' + the URLs for the LTI 'app'.  The title here for each 'app' is only for this listing.  The link on the left side of the nav bar will be taken from the generated XML that is parsed by Canvas.  Do this for each app.  The last part of the URL to append to the base are as follows:

* /canvas/lti_points_configuration
* /canvas/lti_engagement_index
* /canvas/lti_gallery

For the app key, use the value printed out above under 'thor keys:lti_new', and the same for the app secret.   For the URL,

If your datacultures provider app is going to be other than just English, add a line to the config/locales/ yaml file for that language with the field 'app_name' -- see the [English locale file](config/locales/en.yml)  for an example.

API keys are needed to access Canvas data. They cannot be publicly published, so each datacultures instance plus canvas instance must have the correct API keys generated.

An API key with teacher's permissions will be needed for each course that uses the instance.

To create the proper API keys:

    For each course that will uses the backend,
        A. Log in as the instructor
        B. Go to the settings (follow the link in the upper right)
        C. At the bottom of the settings page, click "New Access Token"
        D. Follow the prompts, and don't place an expiration date (so the code won't stop working after that date)
        E. Save this generated token, it will be needed for the Canvas API calls.

The database and Canvas information must be updated.  Do this for each environment you wish to configure (production, qa, staging, development, etc):

From the sample file:
```yaml
production:
  assets:
    served_by_app_server:  false   # set to false where Apache is available
  databases:
    database: 'datacultures_production'
    host: 'localhost'
    port:  5432
  api:
    server:  'http://localhost:3100/'
    course: '1'
    api_key:  'FOOBARBAZ'
```

Configure the 'databases' section with appropriate values:

```yaml
  databases:
    database: 'lti_app_live'
    host: 'https://some.database.host'
    port:  9000
```

and also configure the last section.  This section is for the Canvas instance in which the app is embedded.  If the instructor's API key is 'uq0b5QOsjTfpAjYjXUFSUur7lkX2JkgKJlDNKc+FA3Q3gwmQYTo1MOIpAlt112pfjBeuG0N7bvqP9YGrXWPTmnQ', it might look like this:

```yaml
  api:
    server: 'https://datacultures-canvas.instructure.com/'
    course: '30765'
    api_key:  'uq0b5QOsjTfpAjYjXUFSUur7lkX2JkgKJlDNKc+FA3Q3gwmQYTo1MOIpAlt112pfjBeuG0N7bvqP9YGrXWPTmnQ'
```

### Bundling

The rubygems must be made available.  It is assumed you are now in the project directory:

```shell
~/datacultures $ bundle install
```


### Configuring Engagement Points by student activity

A default setup is provided. The English-language textual description should be entered in the file config/locales/en.yml
or other internationalization file. Under the "activity_types" key, there are entries for each possible activity. The key
there is the internal string representation of the activity (e.g., DiscussionTopic means posting a new Discussion Topic in Canvas.
It is the name that such activity displays in the values returned from the Canvas API. Some types are internal to DataCultures such as 'Entries'
which represents a reply to a DiscussionTopic, or 'Like', 'Dislike' and 'Comment' which all apply to Gallery items.

Each type of Activity must have an entry in the PointsConfiguration table, where:
* pcid is the sort order
* interaction is the code name for the activity
* points_associated is the value for the activity

If you database does not already have all the required PointsConfiguration data, you may populate the table (with random point scores) with:
```shell
$ cd ~/datacultures
~/datacultures $ rake db:seed
```

### Assets (e.g., JavaScripts, CSS files, images)

Assets should be precompiled to run the app. Run:

```shell
$ cd ~/datacultures
~/datacultures $ rake assets:precompile
```

## Testing

### Mocking Configuration

To always mock, set the OS environment variable MOCK to 'always'. To never mock, set MOCK to 'never'.  The default is to mock. So if you wish to actually access the Canvas server in your tests set:

```shell
$ export MOCK=always
```

An alternative way to set the mocking value is to configure it in the ../config/.env_conf.yml file.  Set the following values:

```yaml
test:
  real_requests: false
```

Setting this value to false means mock, setting it to true means make real request in the specs.  The value is set to false in example yaml file.


## Optional steps for development:

The following are all done from a Terminal (or iTerm2) window:

```shell
~/datacultures $ sudo gem install zeus
```

In your development environment, in one shell, start zeus:

    ~/datacultures $ zeus start

In another tab or window, start guard:

    ~/datacultures $ guard

    Now, from other windows (or an edit tool such as RubyMine), change either a spec or the code it is covering, and it will be run in the guard window.

If you have changes to MOCK, to the configuration file (../config/.env_conf.yml) or any other operating system environment, it will be necessary to restart zeus if zeus is in use.
