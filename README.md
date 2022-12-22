# Getting Started

Welcome to your new project.

It contains these folders and files, following our recommended project layout:

File or Folder | Purpose
---------|----------
`app/` | content for UI frontends goes here
`db/` | your domain models and data go here
`srv/` | your service models and code go here
`package.json` | project metadata and configuration
`readme.md` | this getting started guide


## Next Steps

- Open a new terminal and run `cds watch` 
- (in VS Code simply choose _**Terminal** > Run Task > cds watch_)
- Start adding content, for example, a [db/schema.cds](db/schema.cds).


## Learn More

Learn more at https://cap.cloud.sap/docs/get-started/.


# walkthrough

## step 0

pre deploy setup

terminal
```
    cds add mta, approuter, xsuaa, hana 
```
ref - [pre deploy](https://cap.cloud.sap/docs/guides/deployment/to-cf)

./srv/server.js
```
    const cors  = require('cors');
    const cds = require ('@sap/cds')
    cds.on('bootstrap', app => app.use(cors()))
```

habilitamos cors en express, es importante para que appgyver pueda consumir el servicio sin errores


## step 1

Service authentication

ref - [Authentication](https://www.youtube.com/watch?v=ywwbPIRnMBM&list=PLkzo92owKnVwQ-0oT78691fqvHrYXd5oN&index=7&ab_channel=SAPHANAAcademy)

./xs-security.json
```
    "scopes": [
    {
      "name": "uaa.user",
      "description": "UAA"
    },
    ...
    "role-templates":[
    {
      "name": "Token_Exchange",
      "description": "UAA token exchange",
      "scope-references": [
        "uaa.user"
      ]
    },
```

necesitamos un scope para los usuarios authenticados y un role template para el token exchange

./app/xs-app.json
```
    "routes":[
    {
        "source": "^/(.*)$",
        "target": "$1",
        "destination": "srv-api",
        "authenticationType": "basic",
        "scope" : "$XSAPPNAME.Employee"
    },
    ....
```

"authenticationType": "basic" es importante para que el servicio funcione con basic authentication

ref 
    - [xs-app](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/c103fb414988447ead2023f768096dcc.html)
    - [routes](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/666eb55032d849beabb906b18712509b.html)



y ahora podemos pedir usuarios authenticados para consumir el servicio con : @(requires: 'authenticated-user')
./srv/petition-service.cds
```
    service PetitionService 
    @(path: '/service')
    @(requires: 'authenticated-user') //------------enfacis en esta linea-------------------
    {
        entity Petition as projection on my.Petitions;
        ...
    }
```
el resto es parte del servicio que estemos creando actualmente


## step 2 

Service autorization

ref - [autorization](https://www.youtube.com/watch?v=bRs8KPr5rYo&ab_channel=SAPHANAAcademy)

./xs-security.json
```
    "scopes": [
        {
        "name": "uaa.user",
        "description": "UAA"
        },
        { 
        "name": "$XSAPPNAME.Employee",
        "description":"Employee"
        },
        {
        "name": "$XSAPPNAME.Manager",
        "description":"Manager"
        }
    ],
```
agregamos nuevos roles a nuestro scope

./xs-security.json
```
    "role-templates":[
        {
        "name": "Token_Exchange",
        "description": "UAA token exchange",
        "scope-references": [
            "uaa.user"
        ]
        },
        {
        "name": "Employee", "description":"Employee",
        "scope-references":[
            "$XSAPPNAME.Employee"
        ]
        },
        {
        "name": "Manager", "description":"Manager",
        "scope-references":[
            "$XSAPPNAME.Manager"
        ]
        }
    ],
```
agregamos role-templates correspondientes a los scopes

./xs-security.json
```
    "role-collections": [
        {
        "name" : "petition_Employee",
        "description": "making petitions",
        "role-template-references": [
            "$XSAPPNAME.Employee"
        ]
        },
        {
        "name" : "petition_Manager",
        "description": "managing petitions",
        "role-template-references": [
            "$XSAPPNAME.Manager"
        ]
        }
    ],
```
y agregamos role-collections correspondientes a los role-templates

todo esto es necesario para poder asignar roles en el BTP

Ahora podemos Agregar las restricciones que queramos:
./srv/petition-service.cds
```
    service PetitionService 
    @(path: '/service')
    @(requires: 'authenticated-user')
    {
        entity Petition 
            @(restrict: [
                {
                    grant: ['READ'], to: 'Manager'
                },
                {
                    grant: ['WRITE'], to: 'Employee'
                }
            ])
            as projection on my.Petitions;
    ...
```

## step 3

ambientes de production vs development 
ref - [autorization](https://www.youtube.com/watch?v=bRs8KPr5rYo&ab_channel=SAPHANAAcademy)

./package.json
```
    "cds": {
        "requires": {
            "uaa":{
                "kind": "xsuaa" // authentication config
            },
            "db": {
                "[production]":{
                "kind":"hana" // db after deploy
                },
                "[development]" :{
                "kind":"sqlite" // db on development
                }
                
            },
            "auth": {
                "[production]":{
                "strategy" : "JWT" // authentication config
                },
                "[development]" :{
                "strategy": "mock", // authentication y autorization config for development
                "users":{
                    "joe":{
                    "roles": [
                        "Employee"
                    ]
                    },
                    "julie":{
                    "roles": [
                        "Employee"
                    ]
                    },
                    "bob":{
                    "roles": [
                        "Employee",
                        "Manager"
                    ]
                    }
                }
                }
            },
            "approuter": {
                "kind": "cloudfoundry"
            }
        }
    },
```
agregamos esto, eliminamos los comentarios al agregarlo ya que .json no permite comentarios

en la seccion auth.development podemos ver que la estrategia es mock y tenemos algunos usuarios de prueba

podemos proceder a development
terminal
```
    cds watch
```
y ahora podemos consumir el servicio como uno de los usuarios mock, solo poniendo el nombre y sin contraseña
dentro del localhost que se abrio


## step 4 - deployment

ref - [deploy](https://cap.cloud.sap/docs/guides/deployment/to-cf)

./deploy.sh
```
    #!bin/bash

    cds build --production
    mbt build -t gen --mtar mta.tar  
    cf deploy gen/mta.tar
```
agregamos los comandos para hacer deploy y ahora podemos usar el archivo para hacer deploy satisfactoriamente

terminal
```
chmod 701 deploy.sh  # agrega todos los permisos al archivo, solo es necesario usar una vez
./deploy.sh
```


## step 5 - troubleshooting

### falta de login

terminal
```
    cf login --sso
```

o

```
    cf login 
```

### db deploy trouble

./package.json
```
    "cds":{
        "hana": {
            "deploy-format": "hdbtable"
        }
    }
```
ref - [cap-db-deployer-start-crached](https://answers.sap.com/questions/13500726/cap-db-deployer-start-crached.html)

### Error deployment to container my-hdi-container failed - error: HDI make failed [Deployment ID: none]

./db/undeploy.json
```
    [
    "src/gen/**/*.hdbtabledata",
    "src/gen/**/*.csv"
    ]
```
ref - [error-deployment-to-container-my-hdi-container](https://answers.sap.com/questions/13750791/error-deployment-to-container-my-hdi-container-fai.html)

## redirect failed after login

Copiamos el Link de nuestro app router

./xs-secuirty
```
    "oauth2-configuration": {
        "redirect-uris": [
        "https://{AppRouterLink}/login/callback"
        ]
    }
```
es necesario hacer deploy nuevamente
 

## step 6

BTP user roles

dentro del BTP vamos a nuestra subaccount

security > role collections

aqui podemos ver nuestros nuevos roles, en mi caso petition_Employee y petition_Manager.

click en el role que queramos asignar > edit > USERS > ID > asignamos los correos de los usuario que queramos

y save para terminar.

Listo ahora el usuario que asignamos podra consumir el servicio de la manera que queramos.

ref - [roles y autorization](https://www.youtube.com/watch?v=bRs8KPr5rYo&ab_channel=SAPHANAAcademy)

