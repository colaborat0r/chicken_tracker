import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/models/care_log_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/repositories/care_log_repository.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddCareLogScreen extends ConsumerStatefulWidget {
  final CareLogModel? logToEdit;

  const AddCareLogScreen({super.key, this.logToEdit});

  @override
  ConsumerState<AddCareLogScreen> createState() => _AddCareLogScreenState();
}

class _ExistingPhoto {
  final CareLogPhotoModel photo;
  final TextEditingController captionController;

  _ExistingPhoto({required this.photo})
      : captionController = TextEditingController(text: photo.caption ?? '');

  void dispose() => captionController.dispose();
}

class _NewPhoto {
  final File file;
  final TextEditingController captionController;

  _NewPhoto({required this.file}) : captionController = TextEditingController();

  void dispose() => captionController.dispose();
}

class _AddCareLogScreenState extends ConsumerState<AddCareLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;
  final List<_ExistingPhoto> _existingPhotos = [];
  final List<_NewPhoto> _newPhotos = [];
  final List<int> _removedPhotoIds = [];
  bool _isLoading = false;

  bool get _isEdit => widget.logToEdit != null;

  @override
  void initState() {
    super.initState();
    final log = widget.logToEdit;
    _titleController = TextEditingController(text: log?.title ?? 'Care Note');
    _notesController = TextEditingController(text: log?.notes ?? '');
    _selectedDate = log?.date ?? DateTime.now();
    if (log != null) {
      _existingPhotos.addAll(
        log.photos.map((photo) => _ExistingPhoto(photo: photo)),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    for (final photo in _existingPhotos) {
      photo.dispose();
    }
    for (final photo in _newPhotos) {
      photo.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2048,
      );
      if (picked == null) return;
      setState(() {
        _newPhotos.add(_NewPhoto(file: File(picked.path)));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add photo: $e')),
      );
    }
  }

  Future<void> _showPhotoSourceSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) await _pickImage(source);
  }

  void _removeExistingPhoto(_ExistingPhoto photo) {
    setState(() {
      _removedPhotoIds.add(photo.photo.id);
      photo.dispose();
      _existingPhotos.remove(photo);
    });
  }

  void _removeNewPhoto(_NewPhoto photo) {
    setState(() {
      photo.dispose();
      _newPhotos.remove(photo);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(careLogRepositoryProvider);
      final title = _titleController.text.trim().isEmpty
          ? 'Care Note'
          : _titleController.text.trim();
      final notes =
          _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
      final pendingPhotos = _newPhotos
          .map(
            (photo) => PendingCareLogPhoto(
              sourceFile: photo.file,
              caption: photo.captionController.text.trim().isEmpty
                  ? null
                  : photo.captionController.text.trim(),
            ),
          )
          .toList();

      if (_isEdit) {
        final updatedCaptions = <int, String?>{};
        for (final photo in _existingPhotos) {
          final caption = photo.captionController.text.trim();
          updatedCaptions[photo.photo.id] =
              caption.isEmpty ? null : caption;
        }

        await repo.updateCareLog(
          existing: widget.logToEdit!,
          date: _selectedDate,
          title: title,
          notes: notes,
          newPhotos: pendingPhotos,
          removedPhotoIds: _removedPhotoIds,
          updatedCaptions: updatedCaptions,
        );
      } else {
        await repo.addCareLog(
          date: _selectedDate,
          title: title,
          notes: notes,
          pendingPhotos: pendingPhotos,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Care note updated!' : 'Care note saved!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoCount = _existingPhotos.length + _newPhotos.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Care Note' : 'Log Notes'),
      ),
      body: AppFormShell(
        title: _isEdit ? 'Edit Care Note' : 'Log Notes',
        subtitle: 'Record flock observations, treatments, and photos',
        icon: Icons.note_alt_outlined,
        gradient: const [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: TextButton(
                  onPressed: _pickDate,
                  child: const Text('Change'),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'What did you observe or do for the flock?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                minLines: 4,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Photos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '$photoCount attached',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Photos are saved in the app and copied to your phone gallery.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _showPhotoSourceSheet,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Add Photo'),
                  ),
                ],
              ),
              if (photoCount > 0) ...[
                const SizedBox(height: 16),
                ..._existingPhotos.map(_buildExistingPhotoCard),
                ..._newPhotos.map(_buildNewPhotoCard),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isEdit ? 'Save Changes' : 'Save Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingPhotoCard(_ExistingPhoto photo) {
    return _PhotoCard(
      image: FileImage(File(photo.photo.filePath)),
      captionController: photo.captionController,
      onRemove: () => _removeExistingPhoto(photo),
    );
  }

  Widget _buildNewPhotoCard(_NewPhoto photo) {
    return _PhotoCard(
      image: FileImage(photo.file),
      captionController: photo.captionController,
      onRemove: () => _removeNewPhoto(photo),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final ImageProvider image;
  final TextEditingController captionController;
  final VoidCallback onRemove;

  const _PhotoCard({
    required this.image,
    required this.captionController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: image,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: captionController,
                    decoration: const InputDecoration(
                      labelText: 'Caption (optional)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Remove'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
