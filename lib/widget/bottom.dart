import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNav({
    Key? key,
    required this.currentIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définition des items de navigation
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.monetization_on, 'label': 'Earnings'},
      {'icon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.people, 'label': 'Team'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0D0D0D),
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: GoogleFonts.exo2(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.exo2(),
      items: List.generate(navItems.length, (index) {
        final item = navItems[index];
        final bool isSelected = index == currentIndex;

        return BottomNavigationBarItem(
          backgroundColor: const Color(0xFF0D0D0D),
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.transparent,
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
          label: isSelected ? item['label'] as String : "",
        );
      }),
    );
  }
}
