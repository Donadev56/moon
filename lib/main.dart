import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:moon/languages/languages.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/screens/auth/auth.dart';
import 'package:moon/screens/auth/login.dart';
import 'package:moon/screens/dash/downlines.dart';
import 'package:moon/screens/dash/earnings.dart';
import 'package:moon/screens/dash/main.dart';
import 'package:go_router/go_router.dart';
import 'package:moon/screens/dash/matrix/matrix.dart';
import 'package:moon/screens/dash/page_manager.dart';
import 'package:moon/screens/dash/profile.dart';
import 'package:moon/screens/dash/settings/change_theme.dart';
import 'package:moon/screens/dash/withdraw.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
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
          path: '/main',
          builder: (BuildContext context, GoRouterState state) {
            return const PagesManagerView();
          },
        ),
        GoRoute(
          path: '/withdraw',
          builder: (BuildContext context, GoRouterState state) {
            return const Withdraw();
          },
        ),
        GoRoute(
          path: '/settings/change_theme',
          builder: (BuildContext context, GoRouterState state) {
            return const ChangeThemeView();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  AppColors colors = AppColors(
      primaryColor: Color(0XFF0D0D0D),
      themeColor: Colors.greenAccent,
      greenColor: Colors.greenAccent,
      secondaryColor: Color(0XFF121212),
      grayColor: Color(0XFF353535),
      textColor: Colors.white,
      redColor: Colors.pinkAccent);
  Themes themes = Themes();
  String savedThemeName = "";
  Future<void> getSavedTheme() async {
    try {
      final manager = ColorsManager();
      final savedName = await manager.getThemeName();
      setState(() {
        savedThemeName = savedName ?? "";
      });
      final savedTheme = await manager.getDefaultTheme();
      setState(() {
        colors = savedTheme;
      });
    } catch (e) {
      logError(e.toString());
    }
  }

  @override
  void initState() {
    getSavedTheme();
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'fr',
          AppLocale.FR,
          countryCode: 'FR',
          fontFamily: 'Font FR',
        ),
        const MapLocale(
          'ar',
          AppLocale.AR,
          countryCode: 'SA',
          fontFamily: 'Font AR',
        ),
        const MapLocale(
          'bn',
          AppLocale.BN,
          countryCode: 'BD',
          fontFamily: 'Font BN',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Moon BNB',
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      theme: ThemeData(
        fontFamily: _localization.fontFamily,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (var platform in TargetPlatform.values)
              platform: CupertinoPageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: colors.themeColor),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
