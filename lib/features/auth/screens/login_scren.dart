import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:workpleis/core/constants/image_control/image_path.dart';
import 'package:workpleis/features/auth/data/amin_api.dart';
import 'package:workpleis/features/auth/screens/forget_screen.dart';
import 'package:workpleis/features/auth/screens/register_screen.dart';
import 'package:workpleis/features/home/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static final routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// ✅ Gradient stroke painter (no padding trick, no double border)
class _GradientRRectBorderPainter extends CustomPainter {
  _GradientRRectBorderPainter({
    required this.radius,
    required this.strokeWidth,
    required this.gradient,
  });

  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Draw stroke fully inside the widget (avoid dark/extra edge)
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(radius),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientRRectBorderPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradient != gradient;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  late final Future<void> _googleSignInReady;

  static const Color _snackBackground = Color(0xFFF3F4F6);
  static const Color _snackText = Color(0xFF111827);

  void _showLoginSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _snackBackground,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            color: _snackText,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  void _authDebugLog(String message, [Object? detail]) {
    if (!kDebugMode) return;
    debugPrint('[Auth] $message${detail == null ? '' : ': $detail'}');
  }

  List<String> _requestBodyKeys(String body) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map) return decoded.keys.map((k) => k.toString()).toList();
    } catch (_) {}
    return const <String>[];
  }

  String _sanitizeResponseBodyForLog(String body) {
    if (body.length <= 500) return body;
    return '${body.substring(0, 500)}...(truncated)';
  }

  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showLoginSnackBar('Please enter email and password');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final Uri uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
      final String body = jsonEncode(<String, String>{
        'email': email,
        'password': password,
      });
      _authDebugLog('email/password login start', uri.toString());
      _authDebugLog('request body keys', _requestBodyKeys(body));
      final http.Response response = await _postAuth(uri, body);

      if (!mounted) return;

      _authDebugLog('email/password status', response.statusCode);
      _authDebugLog('email/password response', _sanitizeResponseBodyForLog(response.body));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic>? data = _decodeJsonMap(response.body);
        if (data == null) {
          _showLoginSnackBar('Login failed. Invalid server response.');
          return;
        }
        final String? token = _parseAccessToken(data);

        if (token == null || token.isEmpty) {
          _showLoginSnackBar('Login failed. No access token received.');
          return;
        }

        await _saveSessionAndGoHome(token: token, email: email);
        return;
      }

      _showLoginSnackBar(
        _loginErrorMessage(
          response.body,
          fallback: 'Invalid email or password',
        ),
      );
    } catch (e, stack) {
      _authDebugLog('email/password error', '$e\n$stack');
      if (!mounted) return;
      _showLoginSnackBar(_unexpectedAuthErrorMessage(e, provider: 'Email'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<http.Response> _postAuth(Uri uri, String body) async {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              host == 'api.aican.co.il';
    final IOClient client = IOClient(httpClient);
    try {
      return await client.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: body,
      );
    } finally {
      client.close();
    }
  }

  Map<String, dynamic>? _decodeJsonMap(String body) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (e) {
      _authDebugLog('JSON decode failed', e);
    }
    return null;
  }

  String _loginErrorMessage(String body, {String fallback = 'Login failed'}) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final dynamic message = decoded['message'] ?? decoded['error'];
        if (message is List) {
          return message.map((dynamic e) => e.toString()).join('\n');
        }
        if (message != null && message.toString().isNotEmpty) {
          return message.toString();
        }
      }
    } catch (e) {
      _authDebugLog('loginErrorMessage parse failed', e);
    }
    return fallback;
  }

  String? _parseAccessToken(Map<String, dynamic> data) {
    final dynamic token =
        data['access_token'] ?? data['accessToken'] ?? data['token'];
    if (token is String && token.isNotEmpty) return token;
    return null;
  }

  Future<void> _saveSessionAndGoHome({
    required String token,
    required String email,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    if (!mounted) return;
    context.go(HomeScreen.routeName);
  }

  Future<void> _completeAuthResponse(
    http.Response response, {
    required String fallbackEmail,
    required String provider,
  }) async {
    _authDebugLog('$provider API status', response.statusCode);
    _authDebugLog('$provider API response', _sanitizeResponseBodyForLog(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic>? data = _decodeJsonMap(response.body);
      if (data == null) {
        _showLoginSnackBar('Login failed. Invalid server response.');
        return;
      }
      final String? token = _parseAccessToken(data);
      if (token == null || token.isEmpty) {
        _showLoginSnackBar('Login failed. No access token received.');
        return;
      }

      final String? responseEmail = data['email'] as String?;
      final String email = (responseEmail != null && responseEmail.trim().isNotEmpty)
          ? responseEmail.trim()
          : fallbackEmail.trim();
      if (email.isEmpty) {
        _showLoginSnackBar('Login failed. No user email received.');
        return;
      }

      await _saveSessionAndGoHome(token: token, email: email);
      return;
    }

    _showLoginSnackBar(
      _loginErrorMessage(
        response.body,
        fallback: '$provider login failed (${response.statusCode})',
      ),
    );
  }

  String _unexpectedAuthErrorMessage(Object error, {required String provider}) {
    if (error is HandshakeException || error is SocketException) {
      return 'Network error. Please try again.';
    }
    if (error is FormatException) {
      return 'Login failed. Invalid server response.';
    }
    if (error is PlatformException) {
      final String? message = error.message;
      if (message != null && message.isNotEmpty) return message;
      return '$provider login failed (${error.code}).';
    }
    return '$provider login failed. Please try again.';
  }

  String _googleMissingConfigMessage() {
    return 'Google Sign-In is not configured. Set googleClientId and '
        'googleServerClientId in amin_api.dart, then add matching GIDClientID, '
        'GIDServerClientID, and CFBundleURLTypes in ios/Runner/Info.plist.';
  }

  String _googleIdTokenSetupMessage() {
    if (!ApiConstants.hasGoogleServerClientId) {
      return 'Google ID token missing. Add a Web OAuth client ID in '
          'amin_api.dart (googleServerClientId) and GIDServerClientID in '
          'ios/Runner/Info.plist — same Google Cloud project as the iOS client.';
    }
    return 'Google ID token missing. Set googleServerClientId in amin_api.dart '
        'and GIDServerClientID in ios/Runner/Info.plist.';
  }

  String? _googleSetupMessage(String? message) {
    if (message == null || message.isEmpty) return null;
    final String lower = message.toLowerCase();
    if (lower.contains('gidclientid') ||
        lower.contains('no active configuration')) {
      return _googleMissingConfigMessage();
    }
    return null;
  }

  String? _nativePluginSetupMessage(String? message) {
    if (message == null || message.isEmpty) return null;
    if (!message.contains('Unable to establish connection on channel')) {
      return null;
    }
    return 'Native sign-in plugin not loaded. Stop the app, run '
        '"cd ios && pod install", then rebuild with "flutter run" (not hot restart).';
  }

  String _emailFromAppleJwt(String identityToken) {
    try {
      final List<String> parts = identityToken.split('.');
      if (parts.length < 2) return '';
      final String normalized = base64Url.normalize(parts[1]);
      final dynamic payload =
          jsonDecode(utf8.decode(base64Url.decode(normalized)));
      if (payload is Map<String, dynamic>) {
        final dynamic email = payload['email'];
        if (email is String && email.isNotEmpty) return email;
      }
    } catch (_) {}
    return '';
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      _authDebugLog('Google login start');

      await _googleSignInReady;

      if (!ApiConstants.isGoogleSignInConfigured) {
        _showLoginSnackBar(_googleMissingConfigMessage());
        return;
      }

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        _showLoginSnackBar('Google sign-in is not available on this device.');
        return;
      }

      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();
      final String? idToken = account.authentication.idToken;

      _authDebugLog('Google idToken present', idToken != null && idToken.isNotEmpty);

      if (idToken == null || idToken.isEmpty) {
        _showLoginSnackBar(_googleIdTokenSetupMessage());
        return;
      }

      final Uri uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.googleLogin}');
      final String body =
          jsonEncode(<String, String>{'idToken': idToken});

      _authDebugLog('Google API URL', uri.toString());
      _authDebugLog('Google request body keys', _requestBodyKeys(body));

      final http.Response response = await _postAuth(uri, body);
      if (!mounted) return;
      await _completeAuthResponse(
        response,
        fallbackEmail: account.email,
        provider: 'Google',
      );
    } on GoogleSignInException catch (e, stack) {
      _authDebugLog('GoogleSignInException', '${e.code}: ${e.description}\n$stack');
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return;
      }
      if (!mounted) return;
      final String? description = e.description;
      _showLoginSnackBar(
        _googleSetupMessage(description) ??
            (description != null && description.isNotEmpty
                ? description
                : 'Google login failed (${e.code.name}). Check Google Sign-In setup.'),
      );
    } on PlatformException catch (e, stack) {
      _authDebugLog('Google PlatformException', '${e.code}: ${e.message}\n$stack');
      if (!mounted) return;
      _showLoginSnackBar(
        _googleSetupMessage(e.message) ??
            _nativePluginSetupMessage(e.message) ??
            e.message ??
            'Google login failed (${e.code}).',
      );
    } catch (e, stack) {
      _authDebugLog('Google unexpected error', '$e\n$stack');
      if (!mounted) return;
      _showLoginSnackBar(_unexpectedAuthErrorMessage(e, provider: 'Google'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleLogin() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      _authDebugLog('Apple login start');

      final bool isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        _showLoginSnackBar('Apple sign-in is not available on this device.');
        return;
      }

      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? identityToken = credential.identityToken;

      _authDebugLog(
        'Apple identityToken present',
        identityToken != null && identityToken.isNotEmpty,
      );

      if (identityToken == null || identityToken.isEmpty) {
        _showLoginSnackBar(
          'Apple identity token missing. Enable Sign in with Apple for '
          'il.co.aican.flutter in Xcode.',
        );
        return;
      }

      final Map<String, String> body = <String, String>{
        'idToken': identityToken,
      };
      final String? email = credential.email?.trim();
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      final String? given = credential.givenName?.trim();
      final String? family = credential.familyName?.trim();
      if (given != null || family != null) {
        final String fullName = [given, family]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(' ');
        if (fullName.isNotEmpty) {
          body['name'] = fullName;
        }
      }

      final Uri uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appleLogin}');
      final String encodedBody = jsonEncode(body);

      _authDebugLog('Apple API URL', uri.toString());
      _authDebugLog('Apple request body keys', _requestBodyKeys(encodedBody));

      final http.Response response = await _postAuth(uri, encodedBody);
      if (!mounted) return;

      final String fallbackEmail = (email != null && email.isNotEmpty)
          ? email
          : _emailFromAppleJwt(identityToken).isNotEmpty
              ? _emailFromAppleJwt(identityToken)
              : (credential.userIdentifier ?? 'apple_user');

      await _completeAuthResponse(
        response,
        fallbackEmail: fallbackEmail,
        provider: 'Apple',
      );
    } on SignInWithAppleAuthorizationException catch (e, stack) {
      _authDebugLog('Apple authorization error', '${e.code}: ${e.message}\n$stack');
      if (e.code == AuthorizationErrorCode.canceled) return;
      if (!mounted) return;
      _showLoginSnackBar(
        e.message.isNotEmpty
            ? e.message
            : 'Apple login failed (${e.code.name}).',
      );
    } on PlatformException catch (e, stack) {
      _authDebugLog('Apple PlatformException', '${e.code}: ${e.message}\n$stack');
      if (!mounted) return;
      _showLoginSnackBar(
        _nativePluginSetupMessage(e.message) ??
            e.message ??
            'Apple login failed (${e.code}).',
      );
    } catch (e, stack) {
      _authDebugLog('Apple unexpected error', '$e\n$stack');
      if (!mounted) return;
      _showLoginSnackBar(_unexpectedAuthErrorMessage(e, provider: 'Apple'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _initGoogleSignIn() async {
    if (!ApiConstants.isGoogleSignInConfigured) {
      _authDebugLog('GoogleSignIn init skipped', 'googleClientId not configured');
      return;
    }

    try {
      await GoogleSignIn.instance.initialize(
        clientId: ApiConstants.googleClientId,
        serverClientId: ApiConstants.hasGoogleServerClientId
            ? ApiConstants.googleServerClientId
            : ApiConstants.googleClientId,
      );
      _authDebugLog(
        'GoogleSignIn initialized',
        'clientId=${ApiConstants.hasGoogleClientId}, '
        'serverClientId=${ApiConstants.hasGoogleServerClientId}',
      );
    } catch (e, stack) {
      _authDebugLog('GoogleSignIn initialize failed', '$e\n$stack');
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignInReady = _initGoogleSignIn();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // ✅ Field that matches Image-1:
  // - Focus হলে: only thin gradient stroke

// ✅ Field that matches Image-1:
// - Default: NO border, fill #F2F3F5
// - Focus: thin gradient stroke only
Widget _pillField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hint,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  final bool isFocus = focusNode.hasFocus;

  // ✅ required fill color
  final Color fill = Colors.grey.shade300;

  const LinearGradient focusGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0088FE),
      Color(0xFF00D1FF),
    ],
  );

  final double radius = 26.r;

  return CustomPaint(
    foregroundPainter: isFocus
        ? _GradientRRectBorderPainter(
            radius: radius,
            strokeWidth: 0.8, // ✅ thinner (no bold look)
            gradient: focusGradient,
          )
        : null,
    child: ClipRRect(
       clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color:
                  isFocus ? const Color(0xFF0088FE) : const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
            // ✅ ensure no default border at all
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
          ),
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70.h),

                // Logo at top left
                Image.asset(ImagePath.loginLogo, width: 39.w, height: 39.h),

                SizedBox(height: 25.h),

                // Title "Welcome to Aican"
                Text(
                  'Welcome to Aican',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                    fontFamily: 'Inter',
                  ),
                ),

                SizedBox(height: 10.h),

                // Subtitle
                Text(
                  'Please enter your registration email and password.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),
                    fontFamily: 'Inter',
                  ),
                ),

                SizedBox(height: 25.h),

                // ✅ Email (only changed field container logic)
                _pillField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 18.h),

                // ✅ Password (only changed field container logic)
                _pillField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  hint: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 18.h),

                // Login button with gradient
                // just update this button 
                GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Opacity(
                    opacity: _isLoading ? 0.7 : 1,
                    child: Container(
                      width: double.infinity,
                      height: 54.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF0088FE), Color(0xFF00D1FF)],
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                // "Or via social networks" text
                Center(
                  child: Text(
                    'Or via social networks',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                // Social login buttons - Apple first, then Google
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Apple login button
                    Expanded(
                      child: GestureDetector(
                        onTap: _isLoading ? null : _handleAppleLogin,
                        child: Opacity(
                          opacity: _isLoading ? 0.7 : 1,
                          child: Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                              color: const Color(0xFFE1E1E1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImagePath.appleLogo,
                                width: 22.w,
                                height: 22.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Apple',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF111827),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Google login button
                    Expanded(
                      child: GestureDetector(
                        onTap: _isLoading ? null : _handleGoogleLogin,
                        child: Opacity(
                          opacity: _isLoading ? 0.7 : 1,
                          child: Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                              color: const Color(0xFFE1E1E1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImagePath.googleLogo,
                                width: 22.w,
                                height: 22.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF111827),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                // "Forgot Password ?" link at bottom center
                Center(
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).push(ForgotPasswordScreen.routeName);
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0088FE),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 200.h),

                // "Don't have an account? Register" text
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF111827),
                          fontFamily: 'Inter',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {context.push(JoinAicanScreen.routeName);},
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF0088FE),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}