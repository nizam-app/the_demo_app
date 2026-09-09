import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:workpleis/core/constants/image_control/image_path.dart';
import 'package:workpleis/features/auth/data/amin_api.dart';
import 'package:workpleis/features/auth/screens/login_scren.dart';
import 'package:workpleis/features/home/screen/home_screen.dart';

class JoinAicanScreen extends StatefulWidget {
  const JoinAicanScreen({super.key});
  static const routeName = "/join";

  @override
  State<JoinAicanScreen> createState() => _JoinAicanScreenState();
}

// ✅ Gradient stroke painter (thin clean border)
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

class _JoinAicanScreenState extends State<JoinAicanScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  final _nameF = FocusNode();
  final _emailF = FocusNode();
  final _passF = FocusNode();
  final _confirmF = FocusNode();

  bool _agree = false;
  bool _isLoading = false;
  late final Future<void> _googleSignInReady;

  static const Color _snackBackground = Color(0xFFF3F4F6);
  static const Color _snackText = Color(0xFF111827);
  static const String _registerEndpoint =
      '${ApiConstants.baseUrl}${ApiConstants.register}';

  void _authDebugLog(String message, [Object? detail]) {
    if (!kDebugMode) return;
    debugPrint('[Auth/Register] $message${detail == null ? '' : ': $detail'}');
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

  Map<String, dynamic>? _decodeJsonMap(String body) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (e) {
      _authDebugLog('JSON decode failed', e);
    }
    return null;
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

  String _unexpectedAuthErrorMessage(Object error, {required String provider}) {
    if (error is HandshakeException || error is SocketException) {
      return 'Network error. Please try again.';
    }
    if (error is FormatException) {
      return 'Registration failed. Invalid server response.';
    }
    if (error is PlatformException) {
      final String? message = error.message;
      if (message != null && message.isNotEmpty) return message;
      return '$provider registration failed (${error.code}).';
    }
    return '$provider registration failed. Please try again.';
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
      final dynamic payload = jsonDecode(
        utf8.decode(base64Url.decode(normalized)),
      );
      if (payload is Map<String, dynamic>) {
        final dynamic email = payload['email'];
        if (email is String && email.isNotEmpty) return email;
      }
    } catch (_) {}
    return '';
  }

  Future<void> _completeAuthResponse(
    http.Response response, {
    required String fallbackEmail,
    required String provider,
  }) async {
    _authDebugLog('$provider API status', response.statusCode);
    _authDebugLog(
      '$provider API response',
      _sanitizeResponseBodyForLog(response.body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic>? data = _decodeJsonMap(response.body);
      if (data == null) {
        _showRegisterSnackBar('Registration failed. Invalid server response.');
        return;
      }
      final String? token = _parseAccessToken(data);
      if (token == null || token.isEmpty) {
        _showRegisterSnackBar('Registration failed. No access token received.');
        return;
      }

      final String? responseEmail = data['email'] as String?;
      final String email =
          (responseEmail != null && responseEmail.trim().isNotEmpty)
          ? responseEmail.trim()
          : fallbackEmail.trim();
      if (email.isEmpty) {
        _showRegisterSnackBar('Registration failed. No user email received.');
        return;
      }

      _showRegisterSnackBar('Account created successfully');
      await _saveSessionAndGoHome(token: token, email: email);
      return;
    }

    _showRegisterSnackBar(
      _registerErrorMessage(response.body).isNotEmpty
          ? _registerErrorMessage(response.body)
          : '$provider registration failed (${response.statusCode})',
    );
  }

  bool _requireTermsAccepted() {
    if (_agree) return true;
    _showRegisterSnackBar(
      'Please accept Terms and Conditions & Privacy policy',
    );
    return false;
  }

  Future<void> _handleGoogleRegister() async {
    if (_isLoading) return;
    if (!_requireTermsAccepted()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      _authDebugLog('Google register start');
      await _googleSignInReady;

      if (!ApiConstants.isGoogleSignInConfigured) {
        _showRegisterSnackBar(_googleMissingConfigMessage());
        return;
      }

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        _showRegisterSnackBar(
          'Google sign-in is not available on this device.',
        );
        return;
      }

      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();
      final String? idToken = account.authentication.idToken;

      _authDebugLog(
        'Google idToken present',
        idToken != null && idToken.isNotEmpty,
      );

      if (idToken == null || idToken.isEmpty) {
        _showRegisterSnackBar(_googleIdTokenSetupMessage());
        return;
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.googleLogin}',
      );
      final String body = jsonEncode(<String, String>{'idToken': idToken});

      _authDebugLog('Google API URL', uri.toString());
      _authDebugLog('Google request body keys', _requestBodyKeys(body));

      final http.Response response = await _postRegister(uri, body);
      if (!mounted) return;
      await _completeAuthResponse(
        response,
        fallbackEmail: account.email,
        provider: 'Google',
      );
    } on GoogleSignInException catch (e, stack) {
      _authDebugLog(
        'GoogleSignInException',
        '${e.code}: ${e.description}\n$stack',
      );
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return;
      }
      if (!mounted) return;
      final String? description = e.description;
      _showRegisterSnackBar(
        _googleSetupMessage(description) ??
            (description != null && description.isNotEmpty
                ? description
                : 'Google registration failed (${e.code.name}).'),
      );
    } on PlatformException catch (e, stack) {
      _authDebugLog(
        'Google PlatformException',
        '${e.code}: ${e.message}\n$stack',
      );
      if (!mounted) return;
      _showRegisterSnackBar(
        _googleSetupMessage(e.message) ??
            _nativePluginSetupMessage(e.message) ??
            e.message ??
            'Google registration failed (${e.code}).',
      );
    } catch (e, stack) {
      _authDebugLog('Google unexpected error', '$e\n$stack');
      if (!mounted) return;
      _showRegisterSnackBar(_unexpectedAuthErrorMessage(e, provider: 'Google'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleRegister() async {
    if (_isLoading) return;
    if (!_requireTermsAccepted()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      _authDebugLog('Apple register start');

      final bool isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        _showRegisterSnackBar('Apple sign-in is not available on this device.');
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
        _showRegisterSnackBar(
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
        final String fullName = [
          given,
          family,
        ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
        if (fullName.isNotEmpty) {
          body['name'] = fullName;
        }
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.appleLogin}',
      );
      final String encodedBody = jsonEncode(body);

      _authDebugLog('Apple API URL', uri.toString());
      _authDebugLog('Apple request body keys', _requestBodyKeys(encodedBody));

      final http.Response response = await _postRegister(uri, encodedBody);
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
      _authDebugLog(
        'Apple authorization error',
        '${e.code}: ${e.message}\n$stack',
      );
      if (e.code == AuthorizationErrorCode.canceled) return;
      if (!mounted) return;
      _showRegisterSnackBar(
        e.message.isNotEmpty
            ? e.message
            : 'Apple registration failed (${e.code.name}).',
      );
    } on PlatformException catch (e, stack) {
      _authDebugLog(
        'Apple PlatformException',
        '${e.code}: ${e.message}\n$stack',
      );
      if (!mounted) return;
      _showRegisterSnackBar(
        _nativePluginSetupMessage(e.message) ??
            e.message ??
            'Apple registration failed (${e.code}).',
      );
    } catch (e, stack) {
      _authDebugLog('Apple unexpected error', '$e\n$stack');
      if (!mounted) return;
      _showRegisterSnackBar(_unexpectedAuthErrorMessage(e, provider: 'Apple'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _initGoogleSignIn() async {
    if (!ApiConstants.isGoogleSignInConfigured) {
      _authDebugLog(
        'GoogleSignIn init skipped',
        'googleClientId not configured',
      );
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

  void _showRegisterSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _snackBackground,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(color: _snackText, fontFamily: 'Inter'),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    final String name = _nameC.text.trim();
    final String email = _emailC.text.trim();
    final String password = _passC.text;
    final String confirmPassword = _confirmC.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showRegisterSnackBar('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      _showRegisterSnackBar('Passwords do not match');
      return;
    }

    if (!_agree) {
      _showRegisterSnackBar(
        'Please accept Terms and Conditions & Privacy policy',
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final Uri uri = Uri.parse(_registerEndpoint);
      final String body = jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      });

      _authDebugLog('email/password register start', uri.toString());
      _authDebugLog('request body keys', _requestBodyKeys(body));

      final http.Response response = await _postRegister(uri, body);

      if (!mounted) return;

      _authDebugLog('email/password status', response.statusCode);
      _authDebugLog(
        'email/password response',
        _sanitizeResponseBodyForLog(response.body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showRegisterSnackBar(_registerSuccessMessage(response.body));
        context.go(LoginScreen.routeName);
        return;
      }

      _showRegisterSnackBar(_registerErrorMessage(response.body));
    } catch (e, stack) {
      _authDebugLog('email/password error', '$e\n$stack');
      if (!mounted) return;
      _showRegisterSnackBar(_unexpectedAuthErrorMessage(e, provider: 'Email'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<http.Response> _postRegister(Uri uri, String body) async {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              host == 'api.aican.co.il';
    final IOClient client = IOClient(httpClient);
    try {
      return await client.post(
        uri,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: body,
      );
    } finally {
      client.close();
    }
  }

  String _registerApiMessage(String body) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final dynamic message = decoded['message'] ?? decoded['error'];
        if (message is List) {
          return message.map((dynamic e) => e.toString()).join('\n');
        }
        if (message != null) return message.toString();
      }
    } catch (_) {}
    return '';
  }

  String _registerSuccessMessage(String body) {
    final String message = _registerApiMessage(body);
    if (message.isNotEmpty) return message;
    return 'Account created successfully';
  }

  String _registerErrorMessage(String body) {
    final String message = _registerApiMessage(body);
    if (message.isNotEmpty) return message;
    return 'Registration failed';
  }

  @override
  void initState() {
    super.initState();
    _googleSignInReady = _initGoogleSignIn();
    _nameF.addListener(() => setState(() {}));
    _emailF.addListener(() => setState(() {}));
    _passF.addListener(() => setState(() {}));
    _confirmF.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    _nameF.dispose();
    _emailF.dispose();
    _passF.dispose();
    _confirmF.dispose();
    super.dispose();
  }

  Widget _pillField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isFocus = focusNode.hasFocus;

    const fill = Color(0xFFE1E1E1);

    const focusGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF0088FE), Color(0xFFB400FF)],
    );

    final radius = 26.r;

    return CustomPaint(
      foregroundPainter: isFocus
          ? _GradientRRectBorderPainter(
              radius: radius,
              strokeWidth: 1.1,
              gradient: focusGradient,
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
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
                color: const Color(0xFF6B7280),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF111827),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialBtn({
    required String label,
    required String iconPath,
    bool highlighted = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: highlighted
                  ? const Color(0xFF0088FE)
                  : const Color(0xFFE6E8EE),
              width: highlighted ? 1.6 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 22.w, height: 22.w),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF111827),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // ✅ Back button (circle)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      padding: EdgeInsets.all(9.r),
                      decoration: BoxDecoration(
                        color: Color(0xffF3F4F6),
                        shape: BoxShape.circle,
                        // border: Border.all(color: const Color(0xFFE6E8EE)),
                      ),
                      child: Image.asset(
                        "assets/aro.png",
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35.h),
                    Image.asset(
                      ImagePath.loginLogo, // আপনার logo path
                      width: 39.w,
                      height: 39.h,
                      fit: BoxFit.cover,
                    ),

                    SizedBox(height: 25.h),

                    // ✅ Title
                    Text(
                      'Join Aican',
                      style: GoogleFonts.roboto(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // ✅ Subtitle
                    Text(
                      'Create an account and connect your device easily.',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(height: 25.h),

                    _pillField(
                      controller: _nameC,
                      focusNode: _nameF,
                      hint: 'Name',
                    ),
                    SizedBox(height: 18.h),
                    _pillField(
                      controller: _emailC,
                      focusNode: _emailF,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 18.h),
                    _pillField(
                      controller: _passC,
                      focusNode: _passF,
                      hint: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(height: 18.h),
                    _pillField(
                      controller: _confirmC,
                      focusNode: _confirmF,
                      hint: 'Confirm password',
                      obscureText: true,
                    ),

                    SizedBox(height: 18.h),

                    // ✅ Terms row
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 22.w,
                            height: 22.h,
                            child: Checkbox(
                              value: _agree,
                              onChanged: (v) =>
                                  setState(() => _agree = v ?? false),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              side: const BorderSide(color: Color(0xFFE6E8EE)),
                              activeColor: const Color(0xFF0088FE),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // ✅ Expanded বাদ, Flexible ব্যবহার
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF6B7280),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                                children: const [
                                  TextSpan(text: 'Terms and Conditions & '),
                                  TextSpan(
                                    text: 'Privacy policy',
                                    style: TextStyle(
                                      color: Color(0xFF0088FE),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // ✅ Create via email button (blue -> purple)
                    GestureDetector(
                      onTap: _isLoading ? null : _handleRegister,
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
                              colors: [Color(0xFF0088FE), Color(0xFFEB0FFE)],
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
                                    'Create via email',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Center(
                      child: Text(
                        'Or via social networks',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Row(
                      children: [
                        _socialBtn(
                          label: 'Apple',
                          iconPath: ImagePath.appleLogo,
                          highlighted: false,
                          onTap: _isLoading ? null : _handleAppleRegister,
                        ),
                        SizedBox(width: 12.w),
                        _socialBtn(
                          label: 'Google',
                          iconPath: ImagePath.googleLogo,
                          highlighted: false,
                          onTap: _isLoading ? null : _handleGoogleRegister,
                        ),
                      ],
                    ),

                    SizedBox(height: 45.h),

                    // ✅ Bottom login text
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Already have an account ? ',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: const Color(0xFF111827),

                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push(LoginScreen.routeName);
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                color: const Color(0xFF0088FE),

                                fontWeight: FontWeight.w400,
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

              // ✅ logo
            ],
          ),
        ),
      ),
    );
  }
}
