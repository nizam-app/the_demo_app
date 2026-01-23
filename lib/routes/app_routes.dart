import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_snack_bar.dart';
import 'package:workpleis/features/auth/screens/login_scren.dart';
import 'package:workpleis/features/home/screen/home_screen.dart';
import 'package:workpleis/features/profile/screen/profile_screen.dart';
import 'package:workpleis/features/auth/screens/devices_screen.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/voice/screen/voice_screen.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/automations/screen/automations_screen.dart';



import 'error_screen.dart';
class AppRouter {
  static final String initial = LoginScreen.routeName;
 static final GoRouter appRouter = GoRouter(
      initialLocation:initial,
      errorBuilder: (context, state) {
        final String badPath = state.uri.toString();

        return CustomGoErrorPage(
          location: badPath,
          error: state.error,
          onRetry: () => context.go(initial),
          onReport: () {
            GlobalSnackBar.show(context, title: "We're sorry", message: "'Thanks, we'll look into this.'");
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
          path: LoginScreen.routeName,
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
      ]);
}
