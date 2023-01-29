```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

# Coding helper (Flutter)

```
.
├── ...
├── lib
|   ├── src                     # Source folder
|   │   ├── components          # Flutter components (widgets)
|   │   ├── services            # Services for fetching data
|   │   |   ├── ...
|   |   |   └── index.dart      # All services exports 
|   │   ├── context             # Context providers
|   │   |   ├── ...
|   |   |   └── index.dart      # All context provider exports 
|   │   ├── pages               # Getting started guide
|   │   ├── ...
|   |   └── main.dart           # Main material component (widget)
├── pubspec.yaml            # Dependencies
└── ...
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
