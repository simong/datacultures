Previous Step: [Generate LTI tokens](https://github.com/ets-berkeley-edu/datacultures/blob/master/docs/generate_LTI_tokens.md#generate-lti-tokens)

# Configure Canvas
*Note:* the following directions are for a hosted instance. Your milage may vary. 

1. In the browser log-in to Canvas as an admin.
2. Navigate to the course you wish to configure.
3. Select **_Settings_** from the left nav.
4. Click the **_Apps_** tab and click **_View App Configurations_**
5. Repeat for each of the three Data Cultures applications (_Points Configuration, Engagement Index, Gallery_):
  1. Click **_Add New App_** 
  2. In the dialog that appears, set the following configuration settings: 
    * For **Name** enter _a name for reference_ (the actual name comes from the application)
    * For **Consumer Key** enter _the key generated above_
    * For **Shared Secret** enter _the secret generated above_
    * For **Configuration Type** select "By URL"
    * For **Configuration URL** enter the URL and port for the DataCultures server + _the URI for the app_
      * **Example:** `http://learn.berkeley.edu:5000/canvas/canvas/lti_points_configuration`
      * :small_orange_diamond: See below for the 3 app URIs :small_orange_diamond: 
  3. Click **_Submit_** 

  :small_orange_diamond: The three application URIs are: :small_orange_diamond: 
    * `/canvas/lti_points_configuration`
    * `/canvas/lti_engagement_index`
    * `/canvas/lti_gallery`

