Flutter generate types:
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

Keycloak run:
```
kc.bat start-dev --hostname=http://10.0.2.2

realm: code-help
client_id: code-help-flutter
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
<img style="width: 100%" src="https://user-images.githubusercontent.com/46025800/219967643-6302b933-7813-4c40-a6c9-8b74645f299f.png"/>


## Project structure

```
├── code-help-core
|   ├── ...
|   └── pom.xml                     # Project dependencies
├── code-help-forum
|   ├── ...
|   └── pom.xml                     # Project dependencies
├── code-help-flutter
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
└── pom.xml                         # Project dependencies
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
