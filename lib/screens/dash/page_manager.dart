import 'package:flutter/material.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/screens/dash/downlines.dart';
import 'package:moon/screens/dash/earnings.dart';
import 'package:moon/screens/dash/main.dart';
import 'package:moon/screens/dash/profile.dart';
import 'package:moon/screens/dash/settings.dart';
import 'package:moon/screens/dash/withdraw.dart';
import 'package:moon/types/types.dart';
import 'package:moon/utils/colors.dart';
import 'package:moon/utils/themes.dart';
import 'package:moon/widget/bottom.dart';

class PagesManagerView extends StatefulWidget {
  final int pageIndex;
  const PagesManagerView({super.key, this.pageIndex = 2});

  @override
  State<PagesManagerView> createState() => _PagesManagerViewState();
}

class _PagesManagerViewState extends State<PagesManagerView> {
  int currentIndex = 2;

  bool _isInitialized = false;
  Color primaryColor = Colors.orange;

  final List<Widget> _pages = [
    Withdraw(),
    Earnings(),
    DashBoardScreen(),
    DownlinesScreen(),
    SettingsView(),
  ];
  AppColors colors = AppColors(
      primaryColor: Color(0XFF0D0D0D),
      themeColor: Colors.greenAccent,
      greenColor: Colors.greenAccent,
      secondaryColor: Color(0XFF121212),
      grayColor: Color(0XFF353535),
      textColor: Colors.white,
      redColor: Colors.pinkAccent);

  bool saved = false;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final data = ModalRoute.of(context)?.settings.arguments;
      if (data != null && (data as Map<String, dynamic>)["pageIndex"] != null) {
        final index = data["pageIndex"];
        setState(() {
          currentIndex = index;
        });
      }
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    getSavedTheme();
    currentIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNav(
        colors: colors,
        primaryColor: primaryColor,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
