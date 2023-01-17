# Deploy SAP AppGyver App to Fiori Launchpad service

## Description

This is an example of a SAP AppGyver HTML5 app that is accessed by a managed application router and is integrated into the SAP Launchpad service. During the deployment `cf deploy`, the HTML5 app is pushed to the HTML5 Application Repository and uses the Authentication & Authorization service (XSUAA service) and the destination service. The `HTML5Module` are the contents of the ZIP file built with SAP AppGyver Community Edition. Deployment made in a hanatrial account.

##

## Deployment

0. Clone the repository:
    ```
    git clone --branch appgyver-cap-application-sample https://github.com/brtkev/sofos-work.git
    cd appgyver-cap-application-sample/app
    ```
1. Subscribe to the [SAP Launchpad service](https://developers.sap.com/tutorials/cp-portal-cloud-foundry-getting-started.html).
2. Extract your appgyver zip build in the [HTML5module](./HTML5module/) folder
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

# reference

This is cloned and edited from my co-worker [gerardo](https://github.com/GerardoDiaz22/), checkout his [build](https://github.com/GerardoDiaz22/sample-appgyver)