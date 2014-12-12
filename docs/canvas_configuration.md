# Configuring Canvas

## Generate LTI tokens
On the DataCultures server, generate the LTI tokens, a _key_ and a _secret_, that are used to communicate between the Data Cultures LTI provider and the Canvas consumer. 

To generate the tokens, use the following thor task on the Data Cultures instance you will be connecting:
```shell
cd datacultures
thor keys:lti_new
```
The new keys will print out. 

## Configure Canvas
*Note:* the following directions are for a hosted instance. Your milage may vary. 

* In the browser log-in to Canvas as an admin.
* Navigate to the course you wish to configure.
* Select **_Settings_** from the left nav.
* Click the **_Apps_** tab and click **_View App Configurations_**

### For each of the three Data Cultures applications (Points Configuration, Engagement Index, Gallery)

1. Click **_Add New App_** 
2. In the dialog that appears, set the following configuration settings: 
  * For **Consumer Key** enter _the key generated above_
  * For **Shared Secret** enter _the secret generated above_
  * For **Configuration Type** select "By URL"
  * For **URL** enter the URL where Canvas accesses DataCultures including the port + the URI for the _app_. 
    * **Example:** `http://learn.berkeley.edu:5000/canvas/canvas/lti_points_configuration`

3. Repeat for all three applications
 * the three application URIs are:
   * `/canvas/lti_points_configuration`
   * `/canvas/lti_engagement_index`
   * `/canvas/lti_gallery`

