# datacultures

The Data Cultures running in Canvas

## setup

If your datacultures provider app is going to be other than just English, add a line to the config/locales/ yaml file for that language with the field 'app_name' -- see the [English locale file](config/locales/en.yml)

API keys are needed to access Canvas data.  They cannot be publicly published, so each datacultures instance plus canvas instance must have the correct API keys generated.

Do not use 'Developer API' keys, those have a lot of permissions.  Instead make users that will have very limited roles.

Known Roles Needed:
 
|  Role  |  Role Type |  Canvas Permission(s)| 
|:--------:|:------------:|:----------------------:|
| discussions_api |  Course Role |  'View Discussions' |


To create the proper API keys:

    1. Login as Admin (not Site Admin), 
    2. If the course does not yet exist, add it (login as Admin, select the 'Start a New Course' button on the right)  Follow 
    3. Create a user with the 'Teacher' role:
    
        A. Select the course added or having existed, above in No. 1.  (from the top nav bar 'Courses' link, the 'My Courses' should include it).
        B. Click on the "People" link in the left nav bar.
        C. Click on the "+ People" link in the upper right of the middle section.
        D. Follow the prompts, creating a user with the teacher role.
        E. On the right, under that 'logout' link, click on 'Add a New User'
        G. Click on the new user's link
        H. In the login information box in the middle, click 'Add Login'
        I. In the login dialog that appears, add login information.  Even if you have Site Admin access, still use the more limited Admin account to be the owning account.  The account should appear in the middle pane.
        G. Log out of the admin account (or use an incognito window/tab)
        H. login as that user(Masquerade as does not work for this)
        I. Go to the settings (either link)
        J. At the bottom of the settings page, click "New Access Token"
        K. Follow the prompts, and don't place an expiration date (so the code won't stop working after that date)
            
    5. Add to the config/secrets.yml (there is one statically in the repo, but the data should not be checked in) the entries as follows, for all environments (example given is for development).  
    If additional roles other than discussions_api are created above, make an entry for that
    
        test:
          secret_key_base: 60e5483ffefd8b18fb44f4fb8a285d007a1e79a583bbe9bfd1f18722ce204d2a179334b8cd31e629a6c3297906caa6d0ae89db82ce3bfe807d664d8e5f1a6c7d
          requests:
            base_url:  'http://localhost:3100/'
            real: false
            discussion_topic_id: "70239"
            course: "2390"
            api_keys:
              teacher:  ThisShouldBeABigQuiteLongStringOfRandomSeemingLettersAndNumbers1

To always mock, set the OS environment variable MOCK to 'always'.  To never mock, set MOCK to 'never'.

For 'course' above, fill in the course ID number from the instance that will be tested against.  For 'real', set the default (should mocks be use or real requests by default, if the MOCK environment variable is not set).  Set 'real' to true to make actual net work requests in specs, and false to mock them (both only if MOCK environment variable is not set).
Base URL is wherever your Canvas test server is located.

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
