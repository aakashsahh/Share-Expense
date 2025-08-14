import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_bloc.dart';
import 'package:share_expenses/presentation/bloc/member/bloc/member_event.dart';

import '../../../data/models/member.dart';

class AddMemberPage extends StatefulWidget {
  final Member? member;

  const AddMemberPage({super.key, this.member});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _tempImagePath;

  bool get _isEditing => widget.member != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final member = widget.member!;
    _nameController.text = member.name;
    _phoneController.text = member.phone ?? '';
    _emailController.text = member.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(
        pickedFile.path,
      ).copy('${directory.path}/$fileName');

      setState(() {
        _tempImagePath = savedImage.path;
      });
    }
  }

  Future<void> _pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        final fullContact = await FlutterContacts.getContact(
          contact.id,
          withPhoto: true,
        );

        setState(() {
          _nameController.text = fullContact?.displayName ?? '';

          if (fullContact?.phones.isNotEmpty ?? false) {
            _phoneController.text = fullContact!.phones.first.number;
          }

          if (fullContact?.emails.isNotEmpty ?? false) {
            _emailController.text = fullContact!.emails.first.address;
          }
        });

        // If contact has a photo, save it to a temp file
        if (fullContact?.photo != null && fullContact!.photo!.isNotEmpty) {
          final directory = await getApplicationDocumentsDirectory();
          final filePath =
              '${directory.path}/contact_photo_${fullContact.id}.png';
          final file = File(filePath);
          await file.writeAsBytes(fullContact.photo!);

          setState(() {
            _tempImagePath = filePath;
          });
          print(_tempImagePath);
        }
      }
    }
  }

  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        final updatedMember = widget.member!.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          // Keep existing imagePath if not changed
          imagePath: _tempImagePath ?? widget.member!.imagePath,
        );

        context.read<MemberBloc>().add(UpdateMember(updatedMember));
      } else {
        final newMember = Member(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          imagePath: _tempImagePath,
          createdAt: DateTime.now(),
        );
        context.read<MemberBloc>().add(AddMember(newMember));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Member' : 'Add Member'),
        actions: [
          TextButton(
            onPressed: () {
              _saveMember();
              Navigator.pop(context);
            },
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar with border
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4), // Border padding
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage:
                          (_tempImagePath != null ||
                              (_isEditing && widget.member?.imagePath != null))
                          ? FileImage(
                              File(_tempImagePath ?? widget.member!.imagePath!),
                            )
                          : null,
                      child:
                          (_tempImagePath == null &&
                              (!_isEditing || widget.member?.imagePath == null))
                          ? (_nameController.text.isNotEmpty
                                ? Text(
                                    _nameController.text
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const Icon(Icons.person, size: 50))
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.camera_alt,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Import contact button
              TextButton.icon(
                icon: const Icon(Icons.contacts),
                label: const Text("Import from Contacts"),
                onPressed: _pickContact,
              ),

              const SizedBox(height: 24),

              // Form Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name *',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Please enter member name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Big bottom save button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _saveMember();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _isEditing ? 'Update Member' : 'Save Member',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
