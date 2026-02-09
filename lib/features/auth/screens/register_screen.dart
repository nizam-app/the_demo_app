import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workpleis/core/constants/image_control/image_path.dart';
import 'package:workpleis/features/auth/screens/login_scren.dart';

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

  @override
  void initState() {
    super.initState();
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
              color: highlighted ? const Color(0xFF0088FE) : const Color(0xFFE6E8EE),
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

                    _pillField(controller: _nameC, focusNode: _nameF, hint: 'Name'),
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
                              onChanged: (v) => setState(() => _agree = v ?? false),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              side: const BorderSide(color: Color(0xFFE6E8EE)),
                              activeColor: const Color(0xFF0088FE),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    )
                         ,


                    SizedBox(height: 18.h),

                    // ✅ Create via email button (blue -> purple)
                    GestureDetector(
                      onTap: () {
                        // TODO: sign up action
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
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
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
                          onTap: () {},
                        ),
                        SizedBox(width: 12.w),
                        _socialBtn(
                          label: 'Google',
                          iconPath: ImagePath.googleLogo,
                          highlighted: false, // ✅ ইমেজে Google এ blue border আছে
                          onTap: () {},
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