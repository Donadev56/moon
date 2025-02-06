import 'package:flutter/material.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/screens/auth/auth.dart';
import 'package:moon/screens/auth/login.dart';
import 'package:moon/screens/dash/downlines.dart';
import 'package:moon/screens/dash/earnings.dart';
import 'package:moon/screens/dash/main.dart';
import 'package:go_router/go_router.dart';
import 'package:moon/screens/dash/matrix/matrix.dart';
import 'package:moon/screens/dash/profile.dart';
import 'package:moon/screens/dash/withdraw.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  onException: (context, state, router) {
    final String? ref = state.pathParameters['ref'];
    log("Ref : $ref");
    logError('Caught an exception: ${state.error.toString()}');
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) {
            final String url = state.uri.toString();

            RegExp regex = RegExp(r"[?&]ref=([^&]+)");

            Match? match = regex.firstMatch(url);

            String? ref;
            if (match != null) {
              ref = match.group(1);
            }
            log("Ref : -> $ref");
            return AuthScreen(
              ref: ref,
            );
          },
        ),
        GoRoute(
          path: '/dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashBoardScreen();
          },
        ),
        GoRoute(
          path: '/team',
          builder: (BuildContext context, GoRouterState state) {
            return const DownlinesScreen();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: '/preview',
          builder: (BuildContext context, GoRouterState state) {
            return const MatrixScreen();
          },
        ),
        GoRoute(
          path: '/earnings',
          builder: (BuildContext context, GoRouterState state) {
            return const Earnings();
          },
        ),
        GoRoute(
          path: '/withdraw',
          builder: (BuildContext context, GoRouterState state) {
            return const Withdraw();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Moon BNB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
