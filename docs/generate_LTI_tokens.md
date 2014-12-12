## Generate LTI tokens
On the DataCultures server, generate the LTI tokens, a _key_ and a _secret_, that are used to communicate between the Data Cultures LTI provider and the Canvas consumer. 

To generate the tokens, use the following thor task on the Data Cultures instance you will be connecting:
```shell
cd datacultures
thor keys:lti_new
```
The new keys will print out. Mark them down. 

**Note:** If you are configuring Canvas then proceed to the next step: [Configure Canvas](https://github.com/ets-berkeley-edu/datacultures/blob/master/docs/canvas_configuration.md#configure-canvas). If someone else is configuring Canvas, provide them with the tokens and the following directions.
