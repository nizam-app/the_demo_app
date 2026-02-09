import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:workpleis/core/constants/image_control/image_path.dart';
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

  @override
  void initState() {
    super.initState();
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
  // - Extra border/shadow/black edge নাই
  // - Fill সবসময় same grey (Image-1 এর মতো)
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
            padding: EdgeInsets.symmetric(horizontal: 24.w),
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

                SizedBox(height: 20.h),

                // ✅ Password (only changed field container logic)
                _pillField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  hint: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 32.h),

                // Login button with gradient
                GestureDetector(
                  onTap: () {
                    context.go(HomeScreen.routeName);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 54.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.r),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0088FE), Color(0xFF15DFFE)],
                      ),
                    ),
                    child: Center(
                      child: Text(
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

                SizedBox(height: 20.h),

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

                SizedBox(height: 20.h),

                // Social login buttons - Apple first, then Google
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Apple login button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
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
                                width: 26.w,
                                height: 26.h,
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

                    SizedBox(width: 12.w),

                    // Google login button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
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
                                width: 26.w,
                                height: 26.h,
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
                  ],
                ),

                SizedBox(height: 40.h),

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

                SizedBox(height: 130.h),

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

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}