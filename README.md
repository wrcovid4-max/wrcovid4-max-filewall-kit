# filewall-kit

Shared code for FileWall and Cash Memer.

## Languages: add one, the easy way

1. Add an entry to `languages.json`. Copy an existing entry, and fill in:
   - `kotlin` and `swift`: the names used in the code
   - `android` and `ios`: the language codes for each platform
   - `catalog`: the code used in iOS String Catalogs (Chinese is `zh-Hans`)
   - `menu` and `short`: the labels in the 🌐 menu
   - `res`: the string name for the language's display name (for example `language_name_fr`)
   - `rtl`: `true` for right-to-left languages
2. Run `python3 scripts/generate.py`. This rewrites the Android and iOS language code.
3. Add the new language to each app. Run the script with the app's paths:

       python3 scripts/generate.py \
           --android-res <app>/app/src/main/res \
           --ios-catalog <app>/FileWall/Resources/Localizable.xcstrings \
           --ios-plist <app>/FileWall/Resources/Info.plist

   This updates the Android language list and the iOS language list. It also reports any app text still missing.
4. Translate the app's own text into the new language, in each app's `values-…` folder (Android) or String Catalog (iOS). The kit's own labels also need the `language_name_…` string in `src/main/res/values-…/strings.xml`.

Each app still needs its own translations. The kit only handles the language list, the menu and the settings that depend on it.

## Layout

- `languages.json`: the one list of languages
- `scripts/generate.py`: builds the code from the list, and sets up each app
- `src/main/java/com/wrcovid/kit/language/`: Android language code and the selector
- `ios/LanguageKit/`: iOS language list (`LanguageKit`) and globe menu (`LanguageKitUI`)
