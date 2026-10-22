# filewall-kit

Shared Android code for FileWall and Cash Memer.

## Language selector

    import com.wrcovid.kit.language.LanguageSwitcher

    LanguageSwitcher(
        restartBody = stringResource(R.string.language_restart_body),
        onLanguageSaved = { tag -> /* save tag in the app's settings */ },
    )

Each app keeps its own `language_restart_body` text, so each app words it for itself.
