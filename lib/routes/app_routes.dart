import 'package:go_router/go_router.dart';
import 'package:workpleis/core/widget/global_snack_bar.dart';
import 'package:workpleis/features/TCP/screen/tcp_ip_integration.dart';
import 'package:workpleis/features/Zones/screen/zones_screen.dart';
import 'package:workpleis/features/analytics/screen/analytics_screen.dart';
import 'package:workpleis/features/categories/screen/categories_screen.dart';
import 'package:workpleis/features/configuration/screen/configuration_screen.dart';
import 'package:workpleis/features/devices/screen/devices_screen.dart';
import 'package:workpleis/features/auth/screens/forget_screen.dart';
import 'package:workpleis/features/auth/screens/login_scren.dart';
import 'package:workpleis/features/auth/screens/register_screen.dart';
import 'package:workpleis/features/auth/screens/splash_screen.dart';
import 'package:workpleis/features/automations/screen/automations_screen.dart';
import 'package:workpleis/features/home/screen/home_screen.dart';
import 'package:workpleis/features/integrations/screen/Integrations_screen.dart';
import 'package:workpleis/features/interfaces/screen/interfaces_screen.dart';
import 'package:workpleis/features/light_dinning_room/screen/light_dinning_room_screen.dart';
import 'package:workpleis/features/menu/screen/menu_screen.dart';
import 'package:workpleis/features/notifications/screen/notifications_screen.dart';
import 'package:workpleis/features/profile/screen/profile_screen.dart';
import 'package:workpleis/features/settings/screen/settings_screen.dart';
import 'package:workpleis/features/cores/screen/cores_screen.dart';
import 'package:workpleis/features/smart_device/presentation/smart_devices_screen.dart';
import 'package:workpleis/features/user/screen/user_screen.dart';
import 'package:workpleis/features/voice/screen/voice_screen.dart';
import 'package:workpleis/features/zone%20category%20screen/screen/zone-category-screen.dart';

import '../features/core/screen/core_screen.dart';
import '../features/settings/screen/setting_screen.dart';
import '../features/weather/screen/weather_screen.dart';
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
      ),
      GoRoute(
        path: CategoriesScreen.routeName,
        name: CategoriesScreen.routeName,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: ZonesScreen.routeName,
        name: ZonesScreen.routeName,
        builder: (context, state) => ZonesScreen(),
      ),
      GoRoute(
        path: ForgotPasswordScreen.routeName,
        name: ForgotPasswordScreen.routeName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
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
        path: Zone_Category_Screen.routeName,
        name: Zone_Category_Screen.routeName,
        builder: (context, state) => const Zone_Category_Screen(),
      ),
      GoRoute(
        path: AnalyticsScreen.routeName,
        name: AnalyticsScreen.routeName,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: WeatherScreen.routeName,
        name: WeatherScreen.routeName,
        builder: (context, state) => const WeatherScreen(),
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
        path: SettingScreen.routeName,
        name: SettingScreen.routeName,
        builder: (context, state) => const SettingScreen(),
      ),

      GoRoute(
        path: CoresScreen.routeName,
        name: CoresScreen.routeName,
        builder: (context, state) => const CoresScreen(),
      ),

      GoRoute(
        path: CoreScreen.routeName,
        name: CoreScreen.routeName,
        builder: (context, state) => const CoreScreen(),
      ),
      GoRoute(
        path: ConfigurationScreen.routeName,
        name: ConfigurationScreen.routeName,
        builder: (context, state) => const ConfigurationScreen(),
      ),

      GoRoute(
        path: LoginScreen.routeName,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: UsersScreen.routeName,
        name: UsersScreen.routeName,
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: InterfacesScreen.routeName,
        name: InterfacesScreen.routeName,
        builder: (context, state) => const InterfacesScreen(),
      ),

      GoRoute(
        path: IntegrationsScreen.routeName,
        name: IntegrationsScreen.routeName,
        builder: (context, state) => const IntegrationsScreen(),
      ),

      GoRoute(
        path: LightDinningRoomScreen.routeName,
        name: LightDinningRoomScreen.routeName,
        builder: (context, state) => const LightDinningRoomScreen(),
      ), 

      GoRoute(
        path: TcpIpIntegrationScreen.routeName,
        name: TcpIpIntegrationScreen.routeName,
        builder: (context, state) => const TcpIpIntegrationScreen(),
      ),
    ],
  );
}