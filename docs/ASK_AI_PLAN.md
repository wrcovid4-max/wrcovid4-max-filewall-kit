# Ask AI: shared plan for every app and device

Goal: one Ask AI design, used by FileWall and Cash Memer on Android, iPhone, iPad and watch,
and reusable for any new app by adding one file and one setting.

## 1. What is shared

- **The rules:** what the AI may read, consent (hidden files always ask first), history
  limits, how answers are shown, and the disclaimer text.
- **The request format:** the message sent to the AI, the page or file context, and the
  reply format (answer, page references, suggested questions).
- **The languages:** the same `languages.json` list already used by the kit.
- **The backend:** one proxy that holds the Gemini key and enforces the rules.

Not shared: each app's screens, its own file storage, and its own wording.

## 2. The backend (the key never goes in an app)

- One Firebase Cloud Function (Firebase is already used for sync).
- It receives: app id, language, question, and the context the app is allowed to send.
- It checks: the app id is allowed, the request is within limits, and consent was given.
- It calls Gemini with the server-side key, then returns the answer.
- The Gemini key that was posted earlier must be **revoked and replaced**. It should never
  be in any app again.

## 3. The shared rules file

- One file, `ai/ask-ai.json`, holds the rules every app follows: limits, consent text keys,
  disclaimer key, and the prompt template.
- Each platform reads it. A generator (like `languages.json`) writes the Kotlin and Swift
  code, so both platforms behave the same.

## 4. Platform code (thin)

- **Android:** a Compose chat sheet and a client that calls the backend.
- **iOS and iPad:** a SwiftUI sheet and the same client.
- **Watch:** a short reply view only, if needed.
- Chat history and suggestions are stored per app, using the same format.

## 5. Plug-in for a new app

1. Add the kit as a submodule.
2. Register the app id on the backend.
3. Give the app its text and its file-access function.
4. Call `AskAi.open(context, file)` (Android) or `AskAIView(file:)` (iOS).

## 6. What gets removed

Once the shared version works, the old copies are removed from each app:
- FileWall Android: its Gemini client, chat sheet, suggestion cache, chat history and consent code
- FileWall iOS: its Gemini client, chat sheet, chat history store and speech code
- Cash Memer (Android and iOS): its Ask AI code and the key in its build settings

Each app is inventoried before its copy is removed, so nothing is lost.

## 7. Decisions needed

1. **Shared logic:** (a) a generator from one spec, like languages, or (b) Kotlin Multiplatform, which shares real code between Android and iOS. (a) is simpler and safer for your current setup.
2. **Backend:** Firebase Cloud Functions (recommended, since sync already uses Firebase).
3. **Order:** FileWall Android first, then iOS, then Cash Memer.
