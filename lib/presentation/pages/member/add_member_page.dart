import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
    print(widget.member);
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage:
                        (_tempImagePath != null ||
                            (_isEditing && widget.member!.imagePath != null))
                        ? FileImage(
                            File(_tempImagePath ?? widget.member!.imagePath!),
                          )
                        : null,
                    child:
                        (_tempImagePath == null &&
                            (!_isEditing || widget.member!.imagePath == null))
                        ? (_nameController.text.isNotEmpty
                              ? Text(
                                  _nameController.text
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Icon(Icons.person, size: 40))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'Enter member name',
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter member name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter phone number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
