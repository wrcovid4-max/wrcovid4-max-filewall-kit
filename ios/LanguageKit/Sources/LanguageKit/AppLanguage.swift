import Foundation

// GENERATED from languages.json by scripts/generate.py. Do not edit by hand.
// Swift 5.7 (Xcode 14.2) has no `switch` expressions, so every mapping returns explicitly.

/// Every language the apps support.
public enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case english = "en"
    case englishUS = "en-US"
    case englishNZ = "en-NZ"
    case urdu = "ur"
    case chinese = "zh"
    case arabic = "ar"
    case spanish = "es"
    case chineseTraditional = "zh-TW"
    case persian = "fa"
    case punjabi = "pa"
    case punjabiShahmukhi = "pa-PK"

    public var id: String { rawValue }

    /// Right-to-left languages mirror the UI when selected.
    public var isRightToLeft: Bool {
        self == .urdu || self == .arabic || self == .persian || self == .punjabiShahmukhi
    }

    public var displayName: String {
        switch self {
        case .english: return "English (ENG)"
        case .englishUS: return "English US (ENG)"
        case .englishNZ: return "English NZ (ENG)"
        case .urdu: return "Urdu (اردو)"
        case .chinese: return "Chinese (中文)"
        case .arabic: return "Arabic (العربية)"
        case .spanish: return "Spanish (Español)"
        case .chineseTraditional: return "Chinese Traditional (繁體中文)"
        case .persian: return "Persian (فارسی)"
        case .punjabi: return "Punjabi (ਪੰਜਾਬੀ)"
        case .punjabiShahmukhi: return "Punjabi Pakistan (پنجابی)"
        }
    }

    public var locale: Locale { Locale(identifier: rawValue) }
}
