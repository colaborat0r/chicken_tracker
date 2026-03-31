import 'package:flutter/material.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}

class AppFormShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Widget child;

  const AppFormShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class AppSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;
  final String loadingLabel;
  final IconData icon;

  const AppSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
    required this.loadingLabel,
    this.icon = Icons.save,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(isLoading ? loadingLabel : label),
      ),
    );
  }
}

class AppSearchAndRangeBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final int selectedRangeDays;
  final ValueChanged<int> onRangeChanged;
  final List<int> ranges;
  final VoidCallback? onCustomRangePressed;
  final String customRangeLabel;

  const AppSearchAndRangeBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedRangeDays,
    required this.onRangeChanged,
    this.ranges = const [0, 7, 30],
    this.onCustomRangePressed,
    this.customRangeLabel = 'Custom',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search records',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: selectedRangeDays == -1,
                  onSelected: (_) => onRangeChanged(-1),
                ),
                ...ranges.map(
                  (days) => ChoiceChip(
                    label: Text(days == 0 ? 'Today' : '$days d'),
                    selected: selectedRangeDays == days,
                    onSelected: (_) => onRangeChanged(days),
                  ),
                ),
                ChoiceChip(
                  label: Text(customRangeLabel),
                  selected: selectedRangeDays == -2,
                  onSelected: (_) {
                    onRangeChanged(-2);
                    onCustomRangePressed?.call();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppFormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const AppFormSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class AppSkeletonLine extends StatelessWidget {
  final double height;
  final double? width;

  const AppSkeletonLine({
    super.key,
    this.height = 14,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE7E7E7),
      ),
    );
  }
}

class AppSkeletonCard extends StatelessWidget {
  final int lines;

  const AppSkeletonCard({
    super.key,
    this.lines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSkeletonLine(height: 18, width: 180),
            const SizedBox(height: 12),
            ...List.generate(
              lines,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppSkeletonLine(width: index == lines - 1 ? 140 : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
