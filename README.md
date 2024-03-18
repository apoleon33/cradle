# cradle

One album per day

# Install
> No bins are available for the moment, so please build it by [yourself](#build-the-app).

# Build instructions
> Assuming you have flutter as well as all the sdks and toolchains working on your pc.
## clone the repository and cd onto it
```sh
git clone https://github.com/apoleon33/cradle.git
cd cradle
```

## Get dependencies
```sh
flutter pub get
```

## Register to LastFM's API
To get LastFM's api working, you need to get an API key, by [filling up this forms](https://www.last.fm/api/account/create).
Once it's done, create a file at `lib/env/` named `env.dart`, and write inside of it the following lines:
```dart
const LASTFM_KEY = 'yourLastFMKey';
```
Setup should now be completed.

## Build

### For android
#### Build an apk
```sh
flutter build apk
```

#### Build an app bundle
```sh
flutter build appbundle
```

### For IOS
I don't know. Following [the flutter guide](https://docs.flutter.dev/deployment/ios) may work. If you arrive to make it work, please feel free to fill [an issue](https://github.com/apoleon33/cradle/issues/new) or a pull request if changes are needed.

### Other targets
According to flutter concerning the `flutter build` command:
```
Build an executable app or install bundle.

Available subcommands:
  aar         Build a repository containing an AAR and a POM file.
  apk         Build an Android APK file from your app.
  appbundle   Build an Android App Bundle file from your app.
  bundle      Build the Flutter assets directory from your app.
  linux       Build a Linux desktop application.
  web         Build a web application bundle.

```

# TODO-LIST
- [x] better algorithm
- [x] always accurate cover & links
- [x] deactivate spotify link if it does not exist
- [x] app theme based on today's record
- [x] working buttons
  - [x] link to spotify
  - [x] see more (...)
    - [x] Share
    - [x] View in full page
  - [x] group as list/as card
  - [x] ~~top left menu~~ replaced by a bottom bar
  - [x] short RYM description
- [ ] ~~widget~~ postponed
- [ ] ~~notification 1/day~~ postponed
- [x] settings
  - [x] Theme mode
  - [x] change music provider
    - [x] Spotify
    - [x] Apple music
    - [x] Deezer
- [x] Material app logo
- [x] github banner on settings
- [ ] better large screen handling
- [ ] listened to/ not listened to button
- [ ] new icon
- [ ] banner on readme
- [ ] put images in cache
