import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  UserProfile? _profile;
  bool _isLoading = false;
  bool _isEditing = false;
  File? _imageFile;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _occupationController = TextEditingController();
  final _websiteController = TextEditingController();
  List<String> _interests = [];
  Map<String, String> _socialLinks = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getProfile();
      setState(() {
        _profile = profile;
        _fullNameController.text = profile.fullName ?? '';
        _emailController.text = profile.email ?? '';
        _bioController.text = profile.bio ?? '';
        _phoneController.text = profile.phoneNumber ?? '';
        _addressController.text = profile.address ?? '';
        _birthDateController.text = profile.birthDate ?? '';
        _genderController.text = profile.gender ?? '';
        _occupationController.text = profile.occupation ?? '';
        _websiteController.text = profile.website ?? '';
        _interests = profile.interests ?? [];
        _socialLinks = profile.socialLinks ?? {};
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadAvatar();
    }
  }

  Future<void> _uploadAvatar() async {
    if (_imageFile == null) return;

    setState(() => _isLoading = true);
    try {
      final avatarUrl = await _profileService.uploadAvatar(_imageFile!);
      setState(() {
        if (_profile != null) {
          _profile = _profile!.copyWith(avatarUrl: avatarUrl);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading avatar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final updatedProfile = await _profileService.updateProfile(
        fullName: _fullNameController.text,
        email: _emailController.text,
        bio: _bioController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        birthDate: _birthDateController.text,
        gender: _genderController.text,
        occupation: _occupationController.text,
        website: _websiteController.text,
        interests: _interests,
        socialLinks: _socialLinks,
      );
      setState(() => _profile = updatedProfile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profile?.avatarUrl != null
                  ? NetworkImage(_profile!.avatarUrl!)
                  : null,
              child: _profile?.avatarUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _profile?.fullName ?? 'No name added',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          _profile?.email ?? 'No email added',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_profile?.bio ?? 'Bio'),
                const SizedBox(height: 16),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: Text(_profile?.occupation ?? 'Occupation'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.cake),
                  title: Text(_profile?.birthDate ?? 'Birth Date'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(_profile?.gender ?? 'Gender'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(_profile?.phoneNumber ?? 'Phone Number'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(_profile?.address ?? 'Address'),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(_profile?.website ?? 'Profile Link'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                if (_profile?.interests?.isNotEmpty ?? false) ...[                  
                  const Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _profile!.interests!.map((interest) => Chip(
                      label: Text(interest),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_profile?.socialLinks?.isNotEmpty ?? false) ...[                  
                  const Text(
                    'Social Links',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._profile!.socialLinks!.entries.map((entry) => ListTile(
                    leading: const Icon(Icons.link),
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                    contentPadding: EdgeInsets.zero,
                  )).toList(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profile?.avatarUrl != null
                      ? NetworkImage(_profile!.avatarUrl!)
                      : null,
                  child: _profile?.avatarUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value!.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty ? 'Email is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bioController,
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
            validator: (value) =>
                value!.length > 500 ? 'Bio too long' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _birthDateController,
                  decoration: const InputDecoration(
                    labelText: 'Birth Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _birthDateController.text = date.toString().split(' ')[0];
                    }
                  },
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _occupationController,
            decoration: const InputDecoration(
              labelText: 'Occupation',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              labelText: 'Website',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.language),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('Interests'),
            children: [
              Wrap(
                spacing: 8,
                children: [
                  ..._interests.map((interest) => Chip(
                    label: Text(interest),
                    onDeleted: () {
                      setState(() {
                        _interests.remove(interest);
                      });
                    },
                  )).toList(),
                  ActionChip(
                    label: const Icon(Icons.add),
                    onPressed: () async {
                      final controller = TextEditingController();
                      final interest = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Add Interest'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Enter your interest',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, controller.text),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      );
                      if (interest != null && interest.isNotEmpty) {
                        setState(() {
                          _interests.add(interest);
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('Social Links'),
            children: [
              ..._socialLinks.entries.map((entry) => ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _socialLinks.remove(entry.key);
                    });
                  },
                ),
              )).toList(),
              ListTile(
                title: const Text('Add Social Link'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final platformController = TextEditingController();
                    final urlController = TextEditingController();
                    final result = await showDialog<Map<String, String>>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Social Link'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: platformController,
                              decoration: const InputDecoration(
                                hintText: 'Platform (e.g., Twitter, LinkedIn)',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: urlController,
                              decoration: const InputDecoration(
                                hintText: 'Profile URL',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(
                              context,
                              {
                                platformController.text: urlController.text,
                              },
                            ),
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _socialLinks.addAll(result);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _isLoading ? null : () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : () async {
                await _updateProfile();
                if (mounted) {
                  setState(() => _isEditing = false);
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _isEditing ? _buildEditMode() : _buildViewMode(),
            ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _occupationController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}