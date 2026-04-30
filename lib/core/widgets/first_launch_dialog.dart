import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/first_launch_provider.dart';

/// Dialog displayed on first app launch explaining features and offering sample data
class FirstLaunchDialog extends ConsumerWidget {
  const FirstLaunchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Welcome to Chicken Tracker! 🐔'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your offline-first home for managing your flock and egg production.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Key Features:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const _FeatureItem('🐓 Track Your Flock', 'Add chickens, monitor health & status'),
            const _FeatureItem('🥚 Log Production', 'Daily egg counts by type'),
            const _FeatureItem('💰 Financial Tracking', 'Sales, expenses, and profit analysis'),
            const _FeatureItem('📊 Analytics', 'Charts and production trends'),
            const _FeatureItem('📱 Offline-First', 'All data stored locally on your device'),
            const _FeatureItem('💾 Backup & Restore', 'Export and restore your data anytime'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Go to Settings → Backup & Restore → Advanced to load sample data anytime.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[200],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(firstLaunchProvider.notifier).markLaunchComplete();
            Navigator.of(context).pop();
          },
          child: const Text('Start Fresh'),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FeatureItem(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


