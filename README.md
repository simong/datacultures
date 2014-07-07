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
    3. Add roles for the API users. 
        
        A  From the courses menu, select the non-site admin (so that course roles can be created; the Site Admin can only create Admin roles)
        B. From the left nav bar, select 'Permissions'
        C. From the center frame, select the 'Course Roles' tab.
        D. Click on the 'Add Role' button.  
        E. In the popup from the 'Add Roles' button, click on and disable every check mark excpet the one needed for that API (e.g., 'View Discussions' for the Discussions API)
    
    4. Create a user or users to have that role: 
    
        A. Select the course added above in No. 1.  (from the top nav bar 'Courses' link, the 'My Courses' should include it).
        B. Click on the "People" link in the left nav bar.
        C. Click on the "+ People" link in the upper right of the middle section.
        D. Follow the prompts, entering as many users as needed (should only be one user) users, selecting the role previously created from the 'role' drop-down field.
        E. On the right, under that 'logout' link, click on 'Add a New User'
        F. For each new user:
            1. Click on the new user's link
            2. In the login information box in the middle, click 'Add Login'
            3. In the login dialog that appears, add login information.  Even if you have Site Admin access, still use the more limited Admin account to be the owning account.  The account should appear in the middle pane.
        G. Log out of the admin account (or use an incognito window/tab)
        H. For each created user:
            1. login as that user(Masquerade as does not work for this)
            2. Go to the settings (either link)
            3. At the bottom of the settings page, click "New Access Token"
            4. Follow the prompts, and don't place an expiration date (so the code won't stop working after that date)
            
    5. Add to the config/secrets.yml (there is one statically in the repo, but the data should not be checked in) the entries as follows, for all environments (example given is for development).  
    If additional roles other than discussions_api are created above, make an entry for that
    
        development:
          secret_key_base: 60e5483ffefd8b18fb44f4fb8a285d007a1e79a583bbe9bfd1f18722ce204d2a179334b8cd31e629a6c3297906caa6d0ae89db82ce3bfe807d664d8e5f1a6c7d
          requests:
            base_url:  'http://localhost:3100'
            api_keys:
              discussions_api:  ThisShouldBeABigQuiteLongStringOfRandomSeemingLettersAndNumbers1

             
## development

The following are all done from a Terminal (or iTerm2) window:

    $ bundle install
    $ sudo gem install zeus

    In your development environment, in one shell, start zeus:

    $ zeus start

    In another tab or window, start guard:

    $ guard

    Now, from other windows (or an edit tool such as RubyMine), change either a spec or the code it is covering, and it will be run in the guard window.
    
    
