# Mobile app install
[Apk and appbundle](https://drive.google.com/drive/folders/1d7zrgDqzDvvGHYz2a94QZ-8ceIRK_qRB?usp=share_link)

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

## Flutter generate types, run and build:
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

flutter run --dart-define="CODING_HELPER_FORUM_API_URL=http://10.0.2.2/forum" --dart-define="CODING_HELPER_API_URL=http://10.0.2.2/core" --dart-define="AUTH_ISSUER_URL=http://10.0.2.2/iam/realms/code-help"

flutter build appbundle --dart-define="CODING_HELPER_FORUM_API_URL=http://10.0.2.2/forum" --dart-define="CODING_HELPER_API_URL=http://10.0.2.2/core" --dart-define="AUTH_ISSUER_URL=http://10.0.2.2/iam/realms/code-help
```

## Keycloak run (local):
**Important:** realm configuration **(must be json file to be able to import it)**: [code-help.json](https://raw.githubusercontent.com/legendmt25/coding-helper-cross-platform/main/code-help-keycloak-iam/realms/code-help.json)
```
kc.bat start-dev --hostname=http://10.0.2.2

realm: code-help
client_id: code-help-flutter
```

## Generate self-signed certificates and keystore (not needed)
```
Keycloak and nginx:
openssl req --x509 --nodes --days 365 --newkey rsa:2048 --keyout tls.key -out tls.crt --subj "\CN=<domain.net>"
openssl pkcs12 --export --out keycloak.p12 --inkey tls.key -in tls.crt --name keycloak-cert
keytool --importkeystore --srckeystore keycloak.p12 --destkeystore keycloak.jks --srcstoretype pkcs12

Flutter:
keytool --genkey -v --keystore flutter.jks --storetype JKS --keyalg RSA --keysize 2048 --validity 10000 --alias flutter
```

## Docker build
```
LOCAL setup:
docker-compose up

PROD setup
docker-compose -f docker-compose.prod.yml up
```

## Api documentation
[Core api documentation](https://raw.githubusercontent.com/legendmt25/coding-helper-cross-platform/main/code-help-core/code-help-core-api-docs/src/main/resources/code-help-core-api.yaml)
<br/>
[Forum api documentation](https://raw.githubusercontent.com/legendmt25/coding-helper-cross-platform/main/code-help-forum/src/main/resources/forum-api.yaml)

## Mockups
[Figma designs](https://www.figma.com/file/jPnnbfNqoAwo7Cn1DNMH5M/Coding-helper?node-id=0%3A1&t=Ov7dI0u7oWTtRXqm-1)
<br/>
[Prototype](https://www.figma.com/proto/jPnnbfNqoAwo7Cn1DNMH5M/Coding-helper?node-id=0%3A1&t=Ov7dI0u7oWTtRXqm-1)
## Technology stack
<img style="width: 100%" alt="Architecture" src="https://user-images.githubusercontent.com/46025800/222832557-e144e229-d979-4917-a780-e722d2631766.png"/>

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
|   ├── assets
|   |   └── i18n
|   |   |   ├── mk.json             # Macedonian translation text keys file
|   |   |   ├── en.json             # English translation text keys file
|   |   |   └── de.json             # Deutsch translation text keys file
|   ├── api                         # Generated api clients 
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
└── pom.xml                         # Root pom.xml, project dependencies
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
