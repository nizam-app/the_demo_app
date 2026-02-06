import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_snack_bar.dart';
import 'package:workpleis/features/Zones/screen/zones_screen.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/auth/screens/forget_screen.dart';
import 'package:workpleis/features/auth/screens/login_scren.dart';
import 'package:workpleis/features/auth/screens/register_screen.dart';
import 'package:workpleis/features/auth/screens/splash_screen.dart';
import 'package:workpleis/features/automations/screen/automations_screen.dart';
import 'package:workpleis/features/home/screen/home_screen.dart';
import 'package:workpleis/features/menu/screen/menu_screen.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/profile/screen/profile_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';
import 'package:workpleis/features/cores/screen/cores_screen.dart';
import 'package:workpleis/features/smart_device/presentation/smart_devices_screen.dart';
import 'package:workpleis/features/voice/screen/voice_screen.dart';

import 'error_screen.dart';

class AppRouter {
  static final String initial = SplashScreen.routeName;
  static final GoRouter appRouter = GoRouter(
    initialLocation: initial,
    errorBuilder: (context, state) {
      final String badPath = state.uri.toString();

      return CustomGoErrorPage(
        location: badPath,
        error: state.error,
        onRetry: () => context.go(initial),
        onReport: () {
          GlobalSnackBar.show(
            context,
            title: "We're sorry",
            message: "'Thanks, we'll look into this.'",
          );
        },
      );
    },

    routes: <RouteBase>[
      GoRoute(
        path: HomeScreen.routeName,
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: SplashScreen.routeName,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),  GoRoute(
        path: ZonesScreen.routeName,
        name: ZonesScreen.routeName,
        builder: (context, state) => const ZonesScreen(),
      ),  GoRoute(
        path: ForgotPasswordScreen.routeName,
        name: ForgotPasswordScreen.routeName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),  GoRoute(
        path: JoinAicanScreen.routeName,
        name: JoinAicanScreen.routeName,
        builder: (context, state) => const JoinAicanScreen(),
      ),
      GoRoute(
        path: ProfileScreen.routeName,
        name: ProfileScreen.routeName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: DevicesScreen.routeName,
        name: DevicesScreen.routeName,
        builder: (context, state) => const DevicesScreen(),
      ),
      GoRoute(
        path: MenuScreen.routeName,
        name: MenuScreen.routeName,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: AnalyticsScreen.routeName,
        name: AnalyticsScreen.routeName,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: VoiceScreen.routeName,
        name: VoiceScreen.routeName,
        builder: (context, state) => const VoiceScreen(),
      ),
      GoRoute(
        path: NotificationsScreen.routeName,
        name: NotificationsScreen.routeName,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AutomationsScreen.routeName,
        name: AutomationsScreen.routeName,
        builder: (context, state) => const AutomationsScreen(),
      ),

      GoRoute(
        path: SmartDevicesScreen.routeName,
        name: SmartDevicesScreen.routeName,
        builder: (context, state) => const SmartDevicesScreen(),
      ),
      GoRoute(
        path: SettingsScreen.routeName,
        name: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: CoresScreen.routeName,
        name: CoresScreen.routeName,
        builder: (context, state) => const CoresScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}