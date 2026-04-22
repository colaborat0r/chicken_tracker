import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/report_settings_provider.dart';

class ReportSettingsScreen extends ConsumerWidget {
  const ReportSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(reportSettingsProvider);
    final notifier = ref.read(reportSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Report Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: Text(
              'Monthly Snapshot Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Choose which metrics to display on your Farm Report Cards. "Profit/Loss" and "Feed per Egg" are disabled by default.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
              ),
            ),
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.totalEggs,
            settings.totalEggs,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.totalSales,
            settings.totalSales,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.totalExpenses,
            settings.totalExpenses,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.profitLoss,
            settings.profitLoss,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.flockCount,
            settings.flockCount,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.layingCount,
            settings.layingCount,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.feedPerEgg,
            settings.feedPerEgg,
          ),
          _buildMetricTile(
            context,
            ref,
            notifier,
            ReportMetric.layingPercentage,
            settings.layingPercentage,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: OutlinedButton.icon(
              onPressed: () => notifier.resetToDefaults(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset to Defaults'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    WidgetRef ref,
    ReportSettingsNotifier notifier,
    ReportMetric metric,
    bool enabled,
  ) {
    return CheckboxListTile(
      title: Text(metric.label),
      subtitle: Text(metric.description),
      value: enabled,
      onChanged: (bool? value) {
        if (value != null) {
          notifier.setMetricEnabled(metric, value);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

