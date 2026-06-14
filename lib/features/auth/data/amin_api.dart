class ApiConstants {
  static const String baseUrl = "https://api.aican.co.il/backend";
  static const String imageBaseUrl = "https://api.aican.co.il";

  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String googleLogin = "/auth/google";
  static const String appleLogin = "/auth/apple";

  /// iOS OAuth client ID (OAuth 2.0 Client ID → iOS, bundle: il.co.aican.flutter).
  /// Also set the same value as `GIDClientID` in ios/Runner/Info.plist.
  static const String googleClientId =
      '578188168094-3f392vu8bil02tpls9o8vlafukn05sn1.apps.googleusercontent.com';

  /// Web OAuth client ID — required for Google `idToken` sent to the backend.
  /// Create in the same Google Cloud project (OAuth 2.0 → Web application).
  /// Also set the same value as `GIDServerClientID` in ios/Runner/Info.plist.
  static const String googleServerClientId = '';

  static bool get hasGoogleClientId => googleClientId.trim().isNotEmpty;

  static bool get hasGoogleServerClientId =>
      googleServerClientId.trim().isNotEmpty;

  static bool get isGoogleSignInConfigured => hasGoogleClientId;

  /// URL scheme for `CFBundleURLTypes` in Info.plist (derived from [googleClientId]).
  static String get googleIosUrlScheme {
    const String suffix = '.apps.googleusercontent.com';
    if (!googleClientId.endsWith(suffix)) return '';
    final String prefix =
        googleClientId.substring(0, googleClientId.length - suffix.length);
    return 'com.googleusercontent.apps.$prefix';
  }

  static const String forgetPassword = "/auth/forgetPassword";

  // User
  static const String me = "/me";

  // Devices
  static const String myDevices = "/devices";
  static const String adminDevices = "/admin/devices";

  // Zones
  static const String myZones = "/zones";
  static const String adminZones = "/admin/zones";

  // Categories
  static const String myCategories = "/categories";

  static const String adminCategories = "/admin/categories";
}