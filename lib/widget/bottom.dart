import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:moon/types/types.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color primaryColor;
  final AppColors colors;

  const BottomNav({
    Key? key,
    required this.currentIndex,
    this.onTap,
    required this.primaryColor,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définition des items de navigation
    final List<Map<String, dynamic>> navItems = [
      {'icon': LucideIcons.handCoins, 'label': 'withdraw'},
      {'icon': Icons.monetization_on, 'label': 'Earnings'},
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.people, 'label': 'Team'},
      {'icon': Icons.settings, 'label': 'Profile'},
    ];

    return BottomNavigationBar(
      backgroundColor: colors.primaryColor,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: colors.themeColor,
      unselectedItemColor: colors.textColor,
      selectedLabelStyle: GoogleFonts.exo2(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.exo2(),
      items: List.generate(navItems.length, (index) {
        final item = navItems[index];
        final bool isSelected = index == currentIndex;

        return BottomNavigationBarItem(
          backgroundColor: colors.secondaryColor,
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? colors.themeColor.withOpacity(0.2)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? colors.themeColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(item['icon'] as IconData),
            ),
          ),
          label: "",
        );
      }),
    );
  }
}
