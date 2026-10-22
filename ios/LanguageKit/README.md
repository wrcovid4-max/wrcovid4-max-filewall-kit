# LanguageKit (iOS)

Shared language list and 🌐 globe menu for Cash Memer and FileWall on iPhone and iPad.

In Xcode: File > Add Package Dependencies > Add Local, and choose `libs/filewall-kit/ios/LanguageKit` from the app's submodule.

    LanguageGlobeMenu(
        selected: settings.language,
        texts: LanguageMenuTexts(
            accessibilityLabel: L10n.string(.platformLanguages, language: language),
            title: L10n.string(.switchLanguageTitle, language: language),
            body: L10n.string(.switchLanguageBody, language: language),
            confirm: L10n.string(.switchLanguageConfirm, language: language),
            cancel: L10n.string(.switchLanguageCancel, language: language)
        ),
        onSelect: { settings.language = $0 }
    )

The app keeps its own text and settings storage. The package holds only the language list and the menu.
