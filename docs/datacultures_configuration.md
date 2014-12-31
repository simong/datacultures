# Datacultures Configuration

* Copy the sample configuration file to the configuration directory. This is used as a template for the final configuration.

```shell
mkdir -p config
cp datacultures/config/.env_conf.yml.example config/.env_conf.yml
```

The LTI standard specifies that an embedded LTI provider share an application key and application secret for authentication. There is a task to configure them later.

The database, Canvas, and datacultures' own information must be updated. Do this for each environment you wish to configure (production, qa, staging, development, etc):

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
  app:
    lti_secret: '7w+N/m0hjBoweKp9iQMzr49dISFA/t3UD5My58blXHjHGW8QuScKgPpBNFbFdgmtlI6xA9NLxweemiiLuY4XIA=='
    lti_key: 'qa2j57NPb3Wue0Ki7g7pZwN9i3Mg1MqQi+EfJ8UsKtjgbqAiYW56BTT8i1pI2Fvl9dZ+P7xf1cZGqfFQyKvGTQ=='
    secret_key_base: 'K00GCcRCdMwU9a9pqxnBusmJHhda6l/OE5Crao91itBP7OnrOl1rA294kfwPPkfnvMve5dSe5Gp/0vf8UORfDQ=='
    lti_base_url: 'http://localhost:3000/'
```

Edit the configuration file (../config/.env_conf.yml relative the project root, directory created and file copied as above) Configure the 'databases' section with appropriate values:

```yaml
  databases:
    database: 'lti_app_live'
    host: 'https://some.database.host'
    port:  9000
```

Next, configure the api section. This section is for the Canvas instance in which the app is embedded. Note that 'course' must be a string, not an integer. If the [instructor's API key](api_key_generation.md) is 'uq0b5QOsjTfpAjYjXUFSUur7lkX2JkgKJlDNKc+FA3Q3gwmQYTo1MOIpAlt112pfjBeuG0N7bvqP9YGrXWPTmnQ', it might look like this:

```yaml
  api:
    server: 'https://datacultures-canvas.instructure.com/'
    course: '30765'
    api_key:  'uq0b5QOsjTfpAjYjXUFSUur7lkX2JkgKJlDNKc+FA3Q3gwmQYTo1MOIpAlt112pfjBeuG0N7bvqP9YGrXWPTmnQ'
```

Finally, Canvas must know where to get the configuration information to allow the to be embedded in Canvas. Edit the 'lti_base_url' parameter under the 'app' section to where DataCultures is installed (including the port, just as the Canvas paramter does). It might look something like this:
```yaml
  app:
    lti_secret: '7w+N/m0hjBoweKp9iQMzr49dISFA/t3UD5My58blXHjHGW8QuScKgPpBNFbFdgmtlI6xA9NLxweemiiLuY4XIA=='
    lti_key: 'qa2j57NPb3Wue0Ki7g7pZwN9i3Mg1MqQi+EfJ8UsKtjgbqAiYW56BTT8i1pI2Fvl9dZ+P7xf1cZGqfFQyKvGTQ=='
    secret_key_base: 'K00GCcRCdMwU9a9pqxnBusmJHhda6l/OE5Crao91itBP7OnrOl1rA294kfwPPkfnvMve5dSe5Gp/0vf8UORfDQ=='
    lti_base_url: 'http://localhost:3000/'
```
