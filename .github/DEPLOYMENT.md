# Deployment Setup Guide

## GitHub Secrets Required

### Android (Google Play Store)

| Secret | Description |
|--------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded upload keystore (`.jks` file) |
| `ANDROID_KEYSTORE_PASSWORD` | Password for the keystore |
| `ANDROID_KEY_ALIAS` | Alias of the signing key |
| `ANDROID_KEY_PASSWORD` | Password for the key alias |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Google Play API service account JSON (plain text) |

### Firebase (Web Hosting)

| Secret | Description |
|--------|-------------|
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account JSON for hosting deploys |
| `FIREBASE_PROJECT_ID` | Firebase project ID (e.g. `bhakthi-app-12345`) |

---

## One-Time Setup Steps

### 1. Generate Android Upload Keystore

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Encode it for the GitHub secret:
```bash
base64 -i upload-keystore.jks | pbcopy   # macOS
base64 upload-keystore.jks | xclip       # Linux
```

### 2. Google Play Service Account

1. Go to [Google Play Console](https://play.google.com/console) → Setup → API access
2. Link to a Google Cloud project
3. Create a service account with **Release Manager** role
4. Download the JSON key → paste the contents into `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

### 3. Firebase Service Account

Run once to generate:
```bash
firebase init hosting
```

Then in [Firebase Console](https://console.firebase.google.com):
- Project Settings → Service Accounts → Generate new private key
- Paste JSON into `FIREBASE_SERVICE_ACCOUNT`

Or use the Firebase GitHub Action's automatic setup:
```bash
npx firebase-tools@latest init hosting:github
```
This auto-creates the secret in your repo.

### 4. Update Application ID

The app ID has been updated to `com.bhakthi.app` in `android/app/build.gradle.kts`.
Make sure your Play Console app uses the same package name.

---

## Workflow Triggers

### Android Deploy (`deploy-android.yml`)
- **Auto**: Pushes to `main` or version tags (`v*`) → deploys to **internal** track
- **Manual**: `workflow_dispatch` → choose track (internal/alpha/beta/production)

### Web Deploy (`deploy-web.yml`)
- **Pull Requests**: Deploys a preview channel URL (auto-commented on PR)
- **Push to main**: Deploys to live production channel
