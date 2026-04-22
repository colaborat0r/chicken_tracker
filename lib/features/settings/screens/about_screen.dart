import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_constants.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static final Uri _feedbackEmailUri = Uri(
    scheme: 'mailto',
    path: 'thehost22000@yahoo.com',
    queryParameters: {'subject': 'Chicken Tracker Feedback'},
  );

  Future<void> _sendFeedback(BuildContext context) async {
    if (!await launchUrl(_feedbackEmailUri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/icons/app_icon.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Chicken & Egg Production Tracker',
                              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text('Version ${AppConstants.appVersion}', style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                            const SizedBox(height: 6),
                            Text(
                              'Built for homesteaders, backyard farmers, and small flock owners who want to track their egg production the easy way.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _AboutSection(
                    title: 'What This App Does',
                    child: Text(
                      'It helps you log daily egg collection, manage your flock, track feed and costs, and see clear charts of your hens\u2019 productivity, all offline, right on your phone.\n\nJust open the app, tap, and keep your homestead running smoothly.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _AboutSection(
                    title: 'Key Features',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FeatureBullet('Quick daily egg logging (by total or per hen)'),
                        _FeatureBullet('Complete flock management (breeds, ages, notes, and status)'),
                        _FeatureBullet('Feed, expense, and cost tracking'),
                        _FeatureBullet('Beautiful production charts and yearly trends'),
                        _FeatureBullet('Reminders for feeding, cleaning, and health checks'),
                        _FeatureBullet('Full export to CSV or PDF for your records'),
                        _FeatureBullet('Works completely offline - perfect for the barn or field'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AboutSection(
                    title: 'Feedback & Support',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We\u2019re constantly improving the app based on feedback from real chicken keepers like you. Have ideas, found a bug, or want a new feature?',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => _sendFeedback(context),
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Send Feedback'),
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          'Email: thehost22000@yahoo.com',
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _AboutSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final String text;

  const _FeatureBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 2), child: Text('\u2022 ')),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
