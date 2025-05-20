import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_app/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();

  Uint8List? _avatarBytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _emailController.text = user.email ?? '';

    try {
      final snap = await _firestore.collection('userData').doc(user.uid).get();
      if (snap.exists) {
        final data = snap.data();
        _nameController.text = data?['name'] ?? '';
        if (data?['photoBase64'] != null) {
          _avatarBytes = base64Decode(data!['photoBase64']);
        }
      }
    } catch (e) {
      _showSnackBar('Error loading data: $e');
    }

    setState(() => _loading = false);
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _updateName() async {
    try {
      await _firestore.collection('userData').doc(_auth.currentUser!.uid).set({
        'name': _nameController.text.trim(),
      }, SetOptions(merge: true));
      _showSnackBar('Name updated!');
    } catch (e) {
      _showSnackBar('Failed to update name: $e');
    }
  }

  Future<void> _updateEmail() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final oldPassword = _oldPassController.text.trim();
    final newEmail = _emailController.text.trim();

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updateEmail(newEmail);
      _showSnackBar('Email updated!');
    } catch (e) {
      _showSnackBar('Email update failed: $e');
    }
  }

  Future<void> _updatePassword() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final oldPassword = _oldPassController.text.trim();
    final newPassword = _newPassController.text.trim();

    if (newPassword.length < 6) {
      _showSnackBar('New password must be at least 6 characters.');
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      _showSnackBar('Password updated!');
    } catch (e) {
      _showSnackBar('Password update failed: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() => _avatarBytes = bytes);

      await _firestore.collection('userData').doc(_auth.currentUser!.uid).set({
        'photoBase64': base64Encode(bytes),
      }, SetOptions(merge: true));
      _showSnackBar('Profile Picture Updated!');
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,

        // --- Option A: Sign Out in AppBar ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out', 
          ),
        ],
      ),

      // --- Option B: Sign Out at bottom ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _avatarBytes != null
                        ? MemoryImage(_avatarBytes!)
                        : const NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            )
                            as ImageProvider,
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateName,
              child: const Text('Update Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('Update Email'),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _oldPassController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: _newPassController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updatePassword,
              child: const Text('Update Password'),
            ),

            const SizedBox(height: 30),

            // ElevatedButton.icon(
            //   onPressed: _signOut,
            //   icon: const Icon(Icons.logout),
            //   label: const Text('Sign Out'),
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            // ),
          ],
        ),
      ),
    );
  }
}
