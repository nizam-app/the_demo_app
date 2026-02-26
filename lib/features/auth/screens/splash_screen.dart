import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workpleis/features/auth/screens/login_scren.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String routeName = "/splashScreen" ;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go(LoginScreen.routeName);
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ Center Logo + Brand
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _rotationController,
                    child: Image.asset(
                      'assets/image 66 copy.png', // ✅ আপনার আসল path দিন
                      width: 39.w,
                      height: 39.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aican',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1D1D1D),
                          height: 1.0,
                          fontFamily: "Inter"
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'I take it smart',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: const Color(0xFF9E9E9E),
                          fontFamily: "Inter",


                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ✅ Bottom "Welcome to Aican!"
            Positioned(
              left: 0,
              right: 0,
              bottom: 28.h,
              child: Center(
                child:
                RichText(
              text: TextSpan(
              // Use GoogleFonts to define the base style
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                color: const Color(0xFF1D1D1D),
                fontWeight: FontWeight.w400,
              ),
              children: const [
                TextSpan(text: 'Welcome to '),
                TextSpan(
                  text: 'Aican!',
                  style: TextStyle(
                    color: Color(0xFF2196F3),
                    // It inherits 'Roboto' from the parent TextSpan style
                  ),
                ),
              ],
            ),
    )

    ),
            ),
          ],
        ),
      ),
    );
  }
}