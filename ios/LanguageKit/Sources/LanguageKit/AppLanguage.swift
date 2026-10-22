import Foundation

// Swift 5.7 (Xcode 14.2) has no `switch` expressions, so every mapping returns explicitly.

/// Every language the apps support. Copied from Cash Memer, so both apps list the same languages.
public enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case english = "en"
    case englishUS = "en-US"
    case englishNZ = "en-NZ"
    case urdu = "ur"
    case chinese = "zh"
    case chineseTraditional = "zh-TW"
    case spanish = "es"
    case persian = "fa"
    case punjabi = "pa"
    case punjabiShahmukhi = "pa-PK"
    case arabic = "ar"

    public var id: String { rawValue }

    /// Urdu, Arabic, Persian and Shahmukhi are written right-to-left; the UI mirrors when selected.
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
        case .chineseTraditional: return "Chinese Traditional (繁體中文)"
        case .spanish: return "Spanish (Español)"
        case .persian: return "Persian (فارسی)"
        case .punjabi: return "Punjabi (ਪੰਜਾਬੀ)"
        case .punjabiShahmukhi: return "Punjabi Pakistan (پنجابی)"
        case .arabic: return "Arabic (العربية)"
        }
    }

    public var locale: Locale { Locale(identifier: rawValue) }
}
