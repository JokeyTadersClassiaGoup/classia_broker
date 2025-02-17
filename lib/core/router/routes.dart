import 'package:classia_broker/features/auth/presentation/pages/login_page.dart';
import 'package:classia_broker/features/auth/presentation/pages/signup_page.dart';
import 'package:classia_broker/features/auth/presentation/pages/upstox_login.dart';
import 'package:classia_broker/features/home/presentation/home_page.dart';
import 'package:classia_broker/features/home/presentation/instrument_details_page.dart';
import 'package:classia_broker/features/level/presentation/upcoming_page.dart';
import 'package:classia_broker/features/order/1_domian/entity/order_page_args.dart';
import 'package:classia_broker/features/order/2_presentation/order_page.dart';
import 'package:classia_broker/features/otp/presentation/bloc/otp_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/bottom_nav_bar/bottom_nav_bar_page.dart';
import '../../features/level/presentation/level_page.dart';
import '../../features/onboarding/onbarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final route = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    // Initial Route for Splash and Onboarding Screens
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
      routes: [
        GoRoute(
          path: OnBoardingScreen.routeName,
          name: OnBoardingScreen.routeName,
          builder: (context, state) => OnBoardingScreen(
            onDone: () {
              // Navigate to Main Screen after Onboarding is done
              context.goNamed(BottomNavBarPage.routeName);
            },
          ),
        ),
      ],
    ),
    // Main screen, Bottom Navigation Bar Page
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavBarPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomePageProvider.routeName,
              name: HomePageProvider.routeName,
              builder: (context, state) {
                return HomePageProvider(
                  accessToken: state.extra as String?,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: LevelPage.routeName,
              name: LevelPage.routeName,
              builder: (context, state) => LevelPage(),
            ),
          ],
        ),
      ],
    ),
    // Login and Authentication Routes
    GoRoute(
      path: LoginPage.routeName,
      name: LoginPage.routeName,
      builder: (_, state) => LoginPage(),
      routes: <RouteBase>[
        GoRoute(
          path: OtpVerificationPage.routeName,
          name: OtpVerificationPage.routeName,
          builder: (_, state) {
            final args = state.extra as Map<String, dynamic>;
            return OtpVerificationPage(
              verificationId: args['verificationId'],
              userModel: args['userModel'],
              type: args['type'],
            );
          },
        ),
        GoRoute(
          path: SignUpPage.routeName,
          name: SignUpPage.routeName,
          builder: (_, state) => SignUpPage(),
        ),
        GoRoute(
          path: UpstoxLogin.routeName,
          name: UpstoxLogin.routeName,
          builder: (_, state) => UpstoxLogin(),
        ),
      ],
    ),
    // Instrument Details and Order Routes
    GoRoute(
      path: InstrumentDetailsPage.routeName,
      name: InstrumentDetailsPage.routeName,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return InstrumentDetailsPage(
          accessToken: args['accessToken'],
          instrument: args['instrument'],
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: OrderPageProvider.routeName,
          name: OrderPageProvider.routeName,
          builder: (_, state) =>
              OrderPageProvider(orderPageArgs: state.extra as OrderPageArgs),
        ),
      ],
    ),
    // Other Routes
    GoRoute(
      path: UploadPredictionPage.routeName,
      name: UploadPredictionPage.routeName,
      builder: (_, state) => UploadPredictionPage(),
    ),
  ],
);
