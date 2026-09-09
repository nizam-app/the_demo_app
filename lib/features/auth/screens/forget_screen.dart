import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:workpleis/core/constants/image_control/image_path.dart';
import 'package:workpleis/features/auth/data/amin_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = "/forgot";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

// ✅ Thin gradient stroke painter (focus হলে border)
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

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailC = TextEditingController();
  final _emailF = FocusNode();
  bool _isLoading = false;

  static const Color _snackBackground = Color(0xFFF3F4F6);
  static const Color _snackText = Color(0xFF111827);
  static const String _forgotPasswordEndpoint =
      '${ApiConstants.baseUrl}/auth/forgot-password';

  void _authDebugLog(String message, [Object? detail]) {
    if (!kDebugMode) return;
    debugPrint(
      '[Auth/ForgotPassword] $message${detail == null ? '' : ': $detail'}',
    );
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

  void _showForgotPasswordSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  String _forgotPasswordApiMessage(String body) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final dynamic message = decoded['message'] ?? decoded['error'];
        if (message is List) {
          return message.map((dynamic e) => e.toString()).join('\n');
        }
        if (message != null) return message.toString();
      }
    } catch (e) {
      _authDebugLog('JSON decode failed', e);
    }
    return '';
  }

  String _forgotPasswordSuccessMessage(String body) {
    final String message = _forgotPasswordApiMessage(body);
    if (message.isNotEmpty) return message;
    return 'If an account exists for this email, you will receive a password reset link shortly.';
  }

  String _forgotPasswordErrorMessage(String body) {
    final String message = _forgotPasswordApiMessage(body);
    if (message.isNotEmpty) return message;
    return 'Failed to send password reset link.';
  }

  String _unexpectedForgotPasswordErrorMessage(Object error) {
    if (error is HandshakeException || error is SocketException) {
      return 'Network error. Please try again.';
    }
    if (error is FormatException) {
      return 'Failed to send reset link. Invalid server response.';
    }
    return 'Failed to send reset link. Please try again.';
  }

  Future<void> _handleForgotPassword() async {
    if (_isLoading) return;

    final String email = _emailC.text.trim();
    if (email.isEmpty) {
      _showForgotPasswordSnackBar('Please enter your email');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final Uri uri = Uri.parse(_forgotPasswordEndpoint);
      final String body = jsonEncode(<String, String>{'email': email});

      _authDebugLog('forgot password start', uri.toString());
      _authDebugLog('request body keys', _requestBodyKeys(body));

      final http.Response response = await _postForgotPassword(uri, body);

      if (!mounted) return;

      _authDebugLog('forgot password status', response.statusCode);
      _authDebugLog(
        'forgot password response',
        _sanitizeResponseBodyForLog(response.body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showForgotPasswordSnackBar(
          _forgotPasswordSuccessMessage(response.body),
        );
        return;
      }

      _showForgotPasswordSnackBar(_forgotPasswordErrorMessage(response.body));
    } catch (e, stack) {
      _authDebugLog('forgot password error', '$e\n$stack');
      if (!mounted) return;
      _showForgotPasswordSnackBar(_unexpectedForgotPasswordErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<http.Response> _postForgotPassword(Uri uri, String body) async {
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

  @override
  void initState() {
    super.initState();
    _emailF.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailC.dispose();
    _emailF.dispose();
    super.dispose();
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

              // ✅ Back button
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
                      decoration: const BoxDecoration(
                        color: Color(0xffF3F4F6),
                        shape: BoxShape.circle,
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
                    SizedBox(height: 43.h),

                    Image.asset(
                      ImagePath.loginLogo,
                      width: 39.w,
                      height: 39.w,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: 21.h),

                    Text(
                      'Forgot Password',
                      style: GoogleFonts.roboto(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(height: 17.h),

                    Text(
                      'Your confirmation link will be sent to you.',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    _pillField(
                      controller: _emailC,
                      focusNode: _emailF,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 21.h),

                    // ✅ Send button
                    GestureDetector(
                      onTap: _isLoading ? null : _handleForgotPassword,
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
                              colors: [
                                Color(0xFF0088FE),
                                Color(0xFFFE019A),
                                // Color(0xFFFF2D8D),
                              ],
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
                                    'Send',
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
                    SizedBox(height: 420.h),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Have password ? ',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: const Color(0xFF111827),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/login'),
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
            ],
          ),
        ),

        // ✅ Bottom fixed text (MUST be inside Stack)
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   bottom: 12.h,
        //   child:
        //
        //   Center(
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text(
        //           'Have password ? ',
        //           style: GoogleFonts.roboto(
        //             fontSize: 16.sp,
        //             color: const Color(0xFF111827),
        //             fontWeight: FontWeight.w400,
        //           ),
        //         ),
        //         GestureDetector(
        //           onTap: () => context.go('/login'),
        //           child: Text(
        //             'Login',
        //             style: GoogleFonts.roboto(
        //               fontSize: 16.sp,
        //               color: const Color(0xFF0088FE),
        //               fontWeight: FontWeight.w400,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        //],
        //),
      ),
    );
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
}
