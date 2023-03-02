# Build

## Maven build
```
Build project:
mvn clean install

Build project by project:
mvn clean install -pl code-help-forum
mvn clean install -pl code-help-core
mvn clean install -pl code-help-mobile-ui

Run projects:
flutter run
java -jar code-help-forum/target/code-help-forum-0.0.1-SNAPSHOT.jar
java -jar code-help-core/code-help-core-app/target/code-help-core-app-0.0.1-SNAPSHOT.jar
```

## Flutter generate types:
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Keycloak run (local):
**Important:** realm configuration **(must be json file to be able to import it)**: [code-help.json](https://raw.githubusercontent.com/legendmt25/coding-helper-cross-platform/main/code-help-keycloak-iam/realms/code-help.json)
```
kc.bat start-dev --hostname=http://10.0.2.2

realm: code-help
client_id: code-help-flutter
```

## Generate self signed certificates and keystore (not needed)
```
openssl req --x509 --nodes --days 365 --newkey rsa:2048 --keyout tls.key -out tls.crt --subj "\CN=<domain.net>"
openssl pkcs12 --export --out keycloak.p12 --inkey tls.key -in tls.crt --name keycloak-cert
keytool --importkeystore --srckeystore keycloak.p12 --destkeystore keycloak.jks --srcstoretype pkcs12
```

## Docker build
```
LOCAL setup:
docker-compose up

PROD setup
docker-compose -f docker-compose.prod.yml up
```

# Documentation
**Image of home page**, here we have active contests

## Api documentation
[Core api documentation](https://raw.githubusercontent.com/legendmt25/coding-helper-cross-platform/main/code-help-core/code-help-core-api-docs/src/main/resources/code-help-core-api.yaml)
<br/>
[Forum api documentation](https://raw.githubusercontent.com/legendmt25/coding-helper-cross-platform/main/code-help-forum/src/main/resources/forum-api.yaml)

## Mockups
[Figma designs](https://www.figma.com/file/jPnnbfNqoAwo7Cn1DNMH5M/Coding-helper?node-id=0%3A1&t=Ov7dI0u7oWTtRXqm-1)
<br/>
[Prototype](https://www.figma.com/proto/jPnnbfNqoAwo7Cn1DNMH5M/Coding-helper?node-id=0%3A1&t=Ov7dI0u7oWTtRXqm-1)
## Technology stack
<img style="width: 100%" alt="Architecture" src="https://user-images.githubusercontent.com/46025800/219967643-6302b933-7813-4c40-a6c9-8b74645f299f.png"/>


## Project structure

```
...
├── .idea                           # Intellij configuration (run configurations, codeStyles, ...)
|   ├── ...
├── .vscode
|   ├── launch.json                 # Visual studio code run configuration
|   └── settings.json               # Settings for thunder client
├── code-help-keycloak-iam
|   ├── realms                      # Realm configurations
|   |   ├── code-help.json          # Exported code-help realm configuration file
|   └── Dockerfile                  # Docker build file
├── code-help-ingress
|   ├── nginx.conf                  # Nginx reverse proxy configuration
|   └── Dockerfile                  # Docker build file
├── code-help-core
|   ├── ...
|   ├── Dockerfile                  # Docker build file
|   └── pom.xml                     # Project dependencies
|
├── code-help-forum
|   ├── ...
|   ├── Dockerfile                  # Docker build file
|   └── pom.xml                     # Project dependencies
├── code-help-mobile-ui
|   ├── ...
|   ├── lib
|   |   ├── src                     # Source folder
|   |   │   ├── components          # Flutter components (widgets)
|   |   │   ├── services            # Services for fetching data
|   |   │   |   ├── ...
|   |   |   |   └── index.dart      # All services exports 
|   |   │   ├── context             # Context providers
|   |   │   |   ├── ...
|   |   |   |   └── index.dart      # All context provider exports 
|   |   │   ├── pages               # Getting started guide
|   |   │   ├── ...
|   |   │   ├── env.dart            # Enviroment variables
|   |   |   └── main.dart           # Main material component (widget)
|   └── pubspec.yaml                # flutter dependencies
├── docker-compose.yml              # LOCAL docker-compose setup
├── docker-compose.prod.yml         # PROD docker-compose setup
└── pom.xml                         # Project dependencies
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
