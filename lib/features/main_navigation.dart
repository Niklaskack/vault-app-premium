import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'transactions/screens/transactions_screen.dart';
import 'analytics/screens/analytics_screen.dart';
import 'profile/screens/profile_screen.dart';
import '../core/providers/navigation_provider.dart';
import '../core/l10n/app_localizations.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF030712),
        selectedItemColor: const Color(0xFF38B6FF),
        unselectedItemColor: Colors.white.withOpacity(0.3),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 0.5),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined), 
            activeIcon: const Icon(Icons.dashboard), 
            label: l10n.translate('nav_dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined), 
            activeIcon: const Icon(Icons.receipt_long), 
            label: l10n.translate('nav_transactions'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined), 
            activeIcon: const Icon(Icons.analytics), 
            label: l10n.translate('nav_analytics'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline), 
            activeIcon: const Icon(Icons.person), 
            label: l10n.translate('nav_profile'),
          ),
        ],
      ),
    );
  }
}
