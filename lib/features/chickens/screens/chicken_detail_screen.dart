import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/models/chicken_model.dart';

class ChickenDetailScreen extends ConsumerStatefulWidget {
  final ChickenModel chicken;

  const ChickenDetailScreen({
    super.key,
    required this.chicken,
  });

  @override
  ConsumerState<ChickenDetailScreen> createState() =>
      _ChickenDetailScreenState();
}

class _ChickenDetailScreenState extends ConsumerState<ChickenDetailScreen> {
  late TextEditingController _breedController;
  late TextEditingController _notesController;
  String? _selectedEggColor;
  late String _selectedStatus;
  bool _isLoading = false;

  final List<String> _eggColors = ['Brown', 'Colored', 'White', 'Other'];
  final List<String> _statuses = [
    'laying',
    'growing',
    'broody',
    'brooding',
    'retired',
    'sold',
    'deceased'
  ];

  @override
  void initState() {
    super.initState();
    _breedController = TextEditingController(text: widget.chicken.breed);
    _notesController =
        TextEditingController(text: widget.chicken.notes ?? '');
    _selectedEggColor = widget.chicken.eggColor;
    _selectedStatus = widget.chicken.status;
  }

  @override
  void dispose() {
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateChicken() async {
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(chickenRepositoryProvider);
      final updated = widget.chicken.copyWith(
        breed: _breedController.text,
        eggColor: _selectedEggColor,
        status: _selectedStatus,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await repo.updateChicken(updated);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🐔 Chicken updated successfully!')),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating chicken: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteChicken() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chicken?'),
        content: Text(
          'Are you sure you want to delete ${widget.chicken.breed}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(chickenRepositoryProvider);
      await repo.deleteChicken(widget.chicken.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🐔 Chicken deleted')),
      );

      context.pop();
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting chicken: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusEmoji = _getStatusEmoji(_selectedStatus);
    final statusColor = _getStatusColor(_selectedStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chicken Details'),
        actions: [
          if (!_isLoading)
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: _deleteChicken,
                  child: const Text('Delete'),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status card
              Card(
                color: statusColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        statusEmoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.chicken.breed,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.chicken.ageInMonths} ${widget.chicken.ageInMonths == 1 ? 'month' : 'months'} old',
                              style:
                                  Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info section
              Text(
                'Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Breed field
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(
                  label: const Text('Breed'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                enabled: !_isLoading,
              ),
              const SizedBox(height: 12),

              // Egg Color dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedEggColor,
                decoration: InputDecoration(
                  label: const Text('Egg Color'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Unknown'),
                  ),
                  ..._eggColors.map((color) {
                    return DropdownMenuItem(
                      value: color.toLowerCase() == 'other'
                          ? null
                          : color.toLowerCase(),
                      child: Text(color),
                    );
                  }),
                ],
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _selectedEggColor = value),
              ),
              const SizedBox(height: 12),

              // Status dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  label: const Text('Status'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: _getStatusLabel(status),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _selectedStatus = value ?? 'laying'),
              ),
              const SizedBox(height: 12),

              // Notes field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  label: const Text('Notes'),
                  hintText: 'Any additional notes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 4,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

              // Hatch date info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hatch Date',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.chicken.hatchDate.month}/${widget.chicken.hatchDate.day}/${widget.chicken.hatchDate.year}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _updateChicken,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'laying':
        return Colors.green;
      case 'growing':
        return Colors.blue;
      case 'broody':
        return Colors.amber;
      case 'brooding':
        return Colors.orange;
      case 'retired':
        return Colors.grey;
      case 'sold':
        return Colors.purple;
      case 'deceased':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusEmoji(String status) {
    switch (status) {
      case 'laying':
        return '🥚';
      case 'growing':
        return '👶';
      case 'broody':
        return '🪺';
      case 'brooding':
        return '🐣';
      case 'retired':
        return '😴';
      case 'sold':
        return '🤝';
      case 'deceased':
        return '🕊️';
      default:
        return '🐔';
    }
  }

  Widget _getStatusLabel(String status) {
    final statusMap = {
      'laying': '🥚 Laying',
      'growing': '👶 Growing',
      'broody': '🪺 Broody',
      'brooding': '🐣 Brooding',
      'retired': '😴 Retired',
      'sold': '🤝 Sold',
      'deceased': '🕊️ Deceased',
    };
    return Text(statusMap[status] ?? status);
  }
}
