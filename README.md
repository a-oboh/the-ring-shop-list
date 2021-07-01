# The-ring.io Shop List Test

## Getting Started

You need to install flutter for this you can find that on the flutter website:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

Install required dependencies:

`flutter pub get`

Run code generation:

`flutter pub pub run build_runner build --delete-conflicting-outputs`

Run the app

`flutter run --no-sound-null-safety`


## App Info

This app follows the clean architecture pattern, which makes testing easier and isolates features into modules.

_Folder Structure_

- **core**: mostly contains reusable code accross the app

  - error: exceptions and failure classes
  - utils: contains general classes and constants, such as app strings, extensions, app colors etc.

  <br />

- **feature**: each feature that are available in the app are included here, and separated as folders

  - data: all calls made to the remote data/api are included here
  - domain: represents bridge between the data layer and presentation layer, here all abstractions are made before being sent to the presentation layer
  - presentation: includes all classes and methods that make up the screens/pages of the app.
