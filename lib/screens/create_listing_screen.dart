import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lms/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/data/models/file_entity.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/providers/listing_provider.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _allTypes = ['job', 'event', 'post'];
  String _selectedType = 'post';
  DateTime? _eventDate;
  bool _isLoading = false;
  List<FileEntity> _pickedFiles = [];

  void _pickEventDate() async {
    final now = DateTime.now();
    final appTheme = Theme.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: appTheme.copyWith(
            colorScheme: appTheme.colorScheme.copyWith(
              primary: appTheme.primaryColor,
              onPrimary: Colors.white,
              surface: const Color(0xFFFFFBF5),
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: const Color(0xFFFFFBF5),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appTheme.primaryColor,
                textStyle: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFiles.addAll(
          result.files
              .where((file) => file.bytes != null)
              .map((file) => FileEntity.fromBytes(file.bytes!, file.name))
              .toList(),
        );
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == 'event' && _eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event date.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final listingProvider = Provider.of<ListingProvider>(
      context,
      listen: false,
    );

    final newListing = Listing(
      username: 'unknown',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      types: [_selectedType],
      eventDate: _selectedType == 'event' ? _eventDate : null,
      files: _pickedFiles,
    );
    print(newListing.toJson());
    final result = await listingProvider.createListing(newListing);

    setState(() => _isLoading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing created successfully!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create listing.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 8,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter description'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children: _allTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: _selectedType == type,
                        onSelected: (_) => setState(() {
                          _selectedType = type;
                          if (type != 'event') _eventDate = null;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedType == 'event')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Event Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            _eventDate == null
                                ? 'Pick a date'
                                : '${_eventDate!.toLocal()}'.split(' ')[0],
                          ),
                          onPressed: _pickEventDate,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'Attach Images',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Images'),
                    onPressed: _pickImages,
                  ),
                  const SizedBox(height: 8),
                  if (_pickedFiles.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_pickedFiles.length, (index) {
                        final img = _pickedFiles[index];
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                img.bytes,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                splashRadius: 16,
                                onPressed: () {
                                  setState(() {
                                    _pickedFiles.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Submit'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
