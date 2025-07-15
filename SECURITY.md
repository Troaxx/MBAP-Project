# 🔒 Security Guidelines for CarpoolSG

## Sensitive Files & Data

### 🚨 NEVER COMMIT THESE FILES:
- `lib/firebase_options.dart` - Contains Firebase API keys and configuration
- `google-services.json` - Android Firebase configuration
- `GoogleService-Info.plist` - iOS Firebase configuration
- `android/key.properties` - Android signing keys
- `.env` files - Environment variables
- `*.jks`, `*.keystore` - Android signing keystores

### ⚠️ REVIEW BEFORE COMMITTING:
- `lib/services/firebase_service.dart` - Contains Google OAuth client ID
- Any files with API keys, tokens, or credentials

## Current Security Status

### ✅ Properly Secured:
- Firebase configuration files are in `.gitignore`
- Build artifacts and generated files are excluded
- Platform-specific sensitive files are ignored

### ⚠️ Needs Attention:
- Google OAuth Client ID is hardcoded in `firebase_service.dart`
- Consider using environment variables for production

## Before Pushing to GitHub

1. **Check git status**: `git status`
2. **Review changes**: `git diff`
3. **Verify no sensitive files**: Check that no API keys or credentials are being committed
4. **Test locally**: Ensure app works after security changes

## Production Deployment

For production deployment, consider:
- Using environment variables for all API keys
- Implementing proper key rotation
- Using Firebase App Check for additional security
- Enabling Firebase Security Rules

## Emergency Response

If sensitive data was accidentally committed:
1. **Immediately rotate all exposed keys**
2. **Remove from git history**: `git filter-branch` or contact GitHub support
3. **Update Firebase project settings**
4. **Review access logs**

## Contact

For security concerns, contact the development team immediately. 