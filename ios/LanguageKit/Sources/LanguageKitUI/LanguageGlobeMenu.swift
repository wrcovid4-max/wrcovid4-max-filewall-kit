import LanguageKit
import SwiftUI
import UIKit

/// Wording for the language menu. Each app passes its own, from its own localisation.
public struct LanguageMenuTexts {
    public let accessibilityLabel: String
    public let title: String
    public let body: String
    public let confirm: String
    public let cancel: String

    public init(accessibilityLabel: String, title: String, body: String, confirm: String, cancel: String) {
        self.accessibilityLabel = accessibilityLabel
        self.title = title
        self.body = body
        self.confirm = confirm
        self.cancel = cancel
    }
}

/// The 🌐 globe. Opens a menu of every language, asks before switching, then calls `onSelect`.
/// The app decides what switching means (for example, saving the choice to its settings).
public struct LanguageGlobeMenu: View {
    private let selected: AppLanguage
    private let texts: LanguageMenuTexts
    private let tint: Color
    private let onSelect: (AppLanguage) -> Void
    @State private var pending: AppLanguage?

    public init(
        selected: AppLanguage,
        texts: LanguageMenuTexts,
        tint: Color = .accentColor,
        onSelect: @escaping (AppLanguage) -> Void
    ) {
        self.selected = selected
        self.texts = texts
        self.tint = tint
        self.onSelect = onSelect
    }

    public var body: some View {
        Menu {
            ForEach(AppLanguage.allCases) { option in
                Button {
                    if option != selected { pending = option }
                } label: {
                    if option == selected {
                        Label(option.displayName, systemImage: "checkmark")
                    } else {
                        Text(option.displayName)
                    }
                }
            }
        } label: {
            Image(systemName: "globe")
                .font(.body.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(Color(uiColor: .secondarySystemBackground), in: Circle())
                .overlay(Circle().stroke(Color(uiColor: .separator).opacity(0.5), lineWidth: 1))
        }
        .accessibilityLabel(texts.accessibilityLabel)
        .alert(
            texts.title,
            isPresented: Binding(get: { pending != nil }, set: { if !$0 { pending = nil } })
        ) {
            Button(texts.confirm) {
                if let target = pending { onSelect(target) }
                pending = nil
            }
            Button(texts.cancel, role: .cancel) {
                pending = nil
            }
        } message: {
            Text(texts.body)
        }
    }
}
