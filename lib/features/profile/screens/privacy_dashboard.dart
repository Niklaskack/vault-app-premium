import 'package:flutter/material.dart';

class PrivacyDashboard extends StatelessWidget {
  const PrivacyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            context,
            'Zero Knowledge Architecture',
            'Vault uses a zero-knowledge architecture. Your financial data is encrypted on your device and never uploaded to our servers.',
            Icons.vpn_lock,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Local AI Processing',
            'All NLP (Sms parsing) and Fraud detection happens locally using TensorFlow Lite. No data is shared with AI providers.',
            Icons.memory,
          ),
          const SizedBox(height: 16),
          _buildPermissionTile(context, 'SMS Data', 'Used for automatic transaction tracking', true),
          _buildPermissionTile(context, 'Biometrics', 'Used for secure app access', true),
          const Spacer(),
          const Divider(),
          ListTile(
            title: const Text('Delete All Local Data', style: TextStyle(color: Colors.red)),
            subtitle: const Text('This action is irreversible and will wipe all your transactions.'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(BuildContext context, String title, String subtitle, bool enabled) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Switch(value: enabled, onChanged: (v) {}),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This will delete all your local financial history. Secure storage keys will also be reset.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Delete Everything', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
