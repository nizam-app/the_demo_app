import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workpleis/core/constants/image_control/image_path.dart';

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

  Widget _pillEmailField() {
    final isFocus = _emailF.hasFocus;

    const fill = Color(0xFFF2F3F5);

    const focusGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF0088FE),
        Color(0xFFB400FF),
      ],
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
            controller: _emailC,
            focusNode: _emailF,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF8A94A6),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 20.h),

          // ✅ Back button (circle)
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15.w),
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
                  child: Image.asset("assets/aro.png",width: 16.w,height: 16.h,),
                ),
              ),
            ),
          ),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35.h),
                Image.asset(
                  ImagePath.loginLogo, // আপনার logo path
                  width: 39.w,
                  height: 39.w,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 25.h),

                // ✅ Title
                Text(
                  'Forgot Password',
                  style: GoogleFonts.roboto(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),

                  ),
                ),

                SizedBox(height: 10.h),

                // ✅ Subtitle
                Text(
                  'Your confirmation link will be sent to you.',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF111827),

                  ),
                ),

                SizedBox(height: 25.h),

                _pillField(controller: _emailC, focusNode: _emailF, hint: 'Email'),
                SizedBox(height: 18.h),
                    SizedBox(height: 14.h),

                    // ✅ Send button (blue -> pink)
                    GestureDetector(
                      onTap: () {
                        // TODO: send reset email
                      },
                      child: Container(
                        width: double.infinity,
                        height: 54.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28.r),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF0088FE),
                              Color(0xFFB400FF),
                              Color(0xFFFF2D8D),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
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

                    SizedBox(height: 420.h), // bottom text space
                  ],
                ),
              ),
            

            // ✅ Bottom: "Have password ? Login"
            Positioned(
              left: 0,
              right: 0,
              bottom: 2.h,
              child: Center(
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
                      onTap: () {
                        context.go('/login'); // ✅ আপনার login route দিন
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
            ),
          ],
        ),
      ),
    ));
  }

  Widget _pillField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isFocus = focusNode.hasFocus;

    const fill = Color(0xFFF3F4F6);

    const focusGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF0088FE),
        Color(0xFFB400FF),
      ],
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