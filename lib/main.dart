import 'package:flutter/material.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/screens/auth/auth.dart';
import 'package:moon/screens/dash/main.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  onException: (context, state, router) {
    logError('Caught an exception: $state , $router ');
    
  },
  
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthScreen();
          },
        ),
           GoRoute(
          path: '/dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashBoardScreen();
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
