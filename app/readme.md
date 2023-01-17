# Deploy SAP AppGyver App to Fiori Launchpad service

## Description

This is an example of a SAP AppGyver HTML5 app that is accessed by a managed application router and is integrated into the SAP Launchpad service. During the deployment `cf deploy`, the HTML5 app is pushed to the HTML5 Application Repository and uses the Authentication & Authorization service (XSUAA service) and the destination service. The `HTML5Module` are the contents of the ZIP file built with SAP AppGyver Community Edition. Deployment made in a hanatrial account.

## Download and Deployment

1. Subscribe to the [SAP Launchpad service](https://developers.sap.com/tutorials/cp-portal-cloud-foundry-getting-started.html).
2. Download the source code:
    ```
    git clone https://github.com/GerardoDiaz22/sample-appgyver.git
    cd sample-appgyver
    ```
3. Build the project:
    ```
    npm install
    npm run build
    ```
4. Log in to Cloud Foundry:
    ```
    cf login
    ```
5. Deploy the project:
    ```
    cf deploy mta_archives/log-app_1.0.0.mtar
    ```
6. See the URL of the web app:
    ```
    cf html5-list -d -rt launchpad -u
    ```

## Check the Result

### List the Deployed HTML5 Apps
```
$ cf html5-list -d -rt launchpad -u                                 
Getting list of HTML5 applications in org orgname / space dev as firstname.lastname@domain.com...
OK

name        version   app-host-id                            service name   destination name                    last changed                    url   
logapp      1.0.0     fcab8c95-d025-4051-8e12-f5856b2f8358   logservice     log-app-html5-repo-host             Fri, 23 Dec 2022 16:17:02 GMT   https://c9cccae8trial.launchpad.cfapps.us10.hana.ondemand.com/logservice.logapp-1.0.0/  
```

### Check the HTML5 App

Access the URL previously described to view the web app. You are redirected to a sign-on page before you can see the web app.

![webapp](result-app.png)

## Integration with FLP

1. Open Launchpad service
2. Update content of HTML5 Apps in the Content Channel
3. Select HTML5 Apps in the Content Explorer tab of the Content Manager
4. Choose Logs in the item list, then Add to My Content
5. Add Logs to a Rol and a Group
6. Open desired site
7. See the new Logs tile

### Check the FLP view of the HTML5 App

![flpapp](result-flpview.png) 

## Problems

The current configuration of the AppGyver app doesn't allow the use of the navigation stack inside a launchpad context, this problem is caused by the intent based navigation and SAP parameters of a launchpad app which cannot be disabled on the `manifest.json` of the HTML5 app. However, a workaround for this issue is described in the following:

1. Create a new tile in the Content Manager
2. Enter the URL of the app detailed on [Download and Deployment](#download-and-deployment) in the `URL` field
3. Uncheck `Add intent and default SAP parameters to URL`
4. Fill the remaining mandatory fields
5. Save the tile
6. Add Rols and Groups as needed
7. Open site
8. See the manually created App tile

Now we can use the navigation arrows of the launchpad and AppGyver app.

## References

This tutorial was built on the SAP-samples about [HTML5 apps deployment](https://github.com/SAP-samples/multi-cloud-html5-apps-samples/tree/main/managed-html5-runtime-basic-mta).

The solution to the navigation problem was discovered by Aocheng Yang in the comments of [Using BTP Authentication and Destinations with SAP AppGyver *and deploy it to BTP](https://blogs.sap.com/2022/07/01/using-btp-authentication-and-destinations-with-sap-appgyver/).