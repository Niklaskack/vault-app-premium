import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/premium_provider.dart';
import 'privacy_dashboard.dart';
import 'paywall_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Vault User'),
            accountEmail: Text('Privacy Protected'),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy Dashboard'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyDashboard())),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('App Lock'),
            subtitle: const Text('Secure access with biometrics'),
            trailing: Switch(
              value: settings.isLockEnabled,
              onChanged: (v) => ref.read(appSettingsProvider.notifier).setLockEnabled(v),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Data'),
            onTap: () {},
          ),
          const Divider(),
          _buildPremiumTile(context, ref),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Vault'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTile(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    
    return ListTile(
      leading: Icon(Icons.star, color: isPremium ? Colors.amber : Colors.grey),
      title: const Text('Vault Premium'),
      subtitle: Text(isPremium ? 'Lifetime Subscription Active' : 'Unlock bank sync & advanced insights'),
      trailing: isPremium ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.chevron_right),
      onTap: () {
        if (!isPremium) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
        }
      },
    );
  }
}
