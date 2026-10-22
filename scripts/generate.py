#!/usr/bin/env python3
"""Generates the shared language code from languages.json, and sets up each app's languages.

Add a language: add an entry to languages.json, then run this script. See README.md.

    python3 scripts/generate.py
    python3 scripts/generate.py --android-res <app>/src/main/res \
                                --ios-catalog <app>/FileWall/Resources/Localizable.xcstrings \
                                --ios-plist <app>/FileWall/Resources/Info.plist
"""
import argparse
import json
import plistlib
from pathlib import Path

KIT = Path(__file__).resolve().parent.parent
LANGS = json.loads((KIT / "languages.json").read_text(encoding="utf-8"))["languages"]
KOTLIN_OUT = KIT / "src/main/java/com/wrcovid/kit/language/AppLanguage.kt"
SWIFT_OUT = KIT / "ios/LanguageKit/Sources/LanguageKit/AppLanguage.swift"


def kotlin_source():
    rows = []
    for i, lang in enumerate(LANGS):
        end = ";" if i == len(LANGS) - 1 else ","
        rows.append(f'    {lang["kotlin"]}("{lang["android"]}", "{lang["menu"]}", "{lang["short"]}", R.string.{lang["res"]}){end}')
    return f'''package com.wrcovid.kit.language

import androidx.annotation.StringRes
import com.wrcovid.kit.R

/**
 * Every language the apps support. GENERATED from languages.json by scripts/generate.py.
 * Do not edit by hand: add a language to languages.json and run the script.
 */
enum class AppLanguage(
    val tag: String,
    val menuLabel: String,
    val shortLabel: String,
    @StringRes val nameRes: Int,
) {{
{chr(10).join(rows)}

    companion object {{
        /** Maps a locale tag such as "zh-CN" to its language. Unknown tags fall back to English. */
        fun fromTag(appliedTag: String): AppLanguage =
            values().firstOrNull {{ appliedTag.equals(it.tag, ignoreCase = true) }}
                ?: values().firstOrNull {{ appliedTag.startsWith(it.tag) }}
                ?: ENGLISH
    }}
}}
'''


def swift_source():
    cases = "\n".join(f'    case {l["swift"]} = "{l["ios"]}"' for l in LANGS)
    rtl = [f"self == .{l['swift']}" for l in LANGS if l["rtl"]]
    rtl_expr = " || ".join(rtl) if rtl else "false"
    names = "\n".join(f'        case .{l["swift"]}: return "{l["menu"]}"' for l in LANGS)
    return f'''import Foundation

// GENERATED from languages.json by scripts/generate.py. Do not edit by hand.
// Swift 5.7 (Xcode 14.2) has no `switch` expressions, so every mapping returns explicitly.

/// Every language the apps support.
public enum AppLanguage: String, CaseIterable, Codable, Identifiable {{
{cases}

    public var id: String {{ rawValue }}

    /// Right-to-left languages mirror the UI when selected.
    public var isRightToLeft: Bool {{
        {rtl_expr}
    }}

    public var displayName: String {{
        switch self {{
{names}
        }}
    }}

    public var locale: Locale {{ Locale(identifier: rawValue) }}
}}
'''


def android_folder(tag):
    """Maps an Android language tag to its values folder, e.g. zh-TW -> values-zh-rTW."""
    if tag == "en":
        return "values"
    parts = tag.split("-")
    if len(parts) == 2:
        return f"values-{parts[0]}-r{parts[1]}"
    if len(parts) == 3:
        return f"values-b+{parts[0]}+{parts[1]}+{parts[2]}"
    return f"values-{tag}"


def locales_xml():
    lines = ['<?xml version="1.0" encoding="utf-8"?>',
             '<locale-config xmlns:android="http://schemas.android.com/apk/res/android">',
             '    <locale android:name="en" />']
    for lang in LANGS:
        if lang["android"] != "en":
            lines.append(f'    <locale android:name="{lang["android"]}" />')
    lines.append('</locale-config>')
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--android-res", help="an app's app/src/main/res folder")
    parser.add_argument("--ios-catalog", help="an app's Localizable.xcstrings")
    parser.add_argument("--ios-plist", help="an app's Info.plist")
    args = parser.parse_args()

    KOTLIN_OUT.parent.mkdir(parents=True, exist_ok=True)
    SWIFT_OUT.parent.mkdir(parents=True, exist_ok=True)
    KOTLIN_OUT.write_text(kotlin_source(), encoding="utf-8")
    SWIFT_OUT.write_text(swift_source(), encoding="utf-8")
    print(f"Wrote {len(LANGS)} languages to the Android and iOS code.")

    if args.android_res:
        res = Path(args.android_res)
        (res / "xml").mkdir(parents=True, exist_ok=True)
        (res / "xml/locales_config.xml").write_text(locales_xml(), encoding="utf-8")
        print("Updated xml/locales_config.xml")
        for lang in LANGS:
            if lang["android"] != "en" and not (res / android_folder(lang["android"]) / "strings.xml").exists():
                print(f"  MISSING Android text for {lang['menu']}: create {android_folder(lang['android'])}/strings.xml")

    if args.ios_catalog:
        cat = json.loads(Path(args.ios_catalog).read_text(encoding="utf-8"))
        for lang in LANGS:
            if lang["catalog"] == "en":
                continue
            count = sum(1 for e in cat["strings"].values()
                        if lang["catalog"] in e.get("localizations", {}))
            if count == 0:
                print(f"  MISSING iOS text for {lang['menu']}: add translations with the code '{lang['catalog']}'")

    if args.ios_plist:
        path = Path(args.ios_plist)
        with path.open("rb") as f:
            plist = plistlib.load(f)
        plist["CFBundleLocalizations"] = ["en"] + [l["catalog"] for l in LANGS if l["catalog"] != "en"]
        with path.open("wb") as f:
            plistlib.dump(plist, f)
        print("Updated CFBundleLocalizations in Info.plist")


if __name__ == "__main__":
    main()
