import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// removed unused imports
// device info removed: profile page now only supports edit + logout
import 'package:shared_preferences/shared_preferences.dart';

typedef OnProfileSave = Future<void> Function(String name, String email, String avatarPath);

class _EditProfileForm extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialAvatar;
  final OnProfileSave onSave;

  const _EditProfileForm({Key? key, required this.initialName, required this.initialEmail, required this.initialAvatar, required this.onSave}) : super(key: key);

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _avatarCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _avatarCtrl = TextEditingController(text: widget.initialAvatar);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Widget _avatarPreview() {
    final path = _avatarCtrl.text.trim();
    if (path.isEmpty) return const CircleAvatar(radius: 48, backgroundColor: Colors.grey);
    if (path.startsWith('http')) return CircleAvatar(radius: 48, backgroundImage: NetworkImage(path));
    // asset
    return CircleAvatar(radius: 48, backgroundImage: AssetImage(path));
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _avatarCtrl.text.trim().isEmpty ? 'assets/profil.png' : _avatarCtrl.text.trim());
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: _avatarPreview()),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              
              final ctrl = TextEditingController(text: _avatarCtrl.text);
              final result = await showDialog<String?>(context: context, builder: (ctx) => AlertDialog(
                title: const Text('Change Photo (asset path or URL)'),
                content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'assets/profil.png or https://...')),
                actions: [TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('OK'))],
              ));
              if (result != null) setState(() => _avatarCtrl.text = result);
            },
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Change Photo'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter email';
              final email = v.trim();
              if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(email)) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : _onSavePressed,
                  child: _saving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String email;
  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // no device info state needed
  String? _displayName;
  String? _avatarPath; 

  @override
  void initState() {
    super.initState();
    
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString('displayName') ?? _displayNameFromEmail(widget.email);
      _avatarPath = prefs.getString('avatarPath') ?? 'assets/profil.png';
    });
  }

  Future<void> _saveProfile({String? name, String? avatarPath}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('displayName', name);
    if (avatarPath != null) await prefs.setString('avatarPath', avatarPath);
  }




  @override
  Widget build(BuildContext context) {
  final email = widget.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.poppins()),
        backgroundColor: const Color.fromRGBO(255, 187, 214, 1),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _EditProfileForm(
            initialName: _displayName ?? _displayNameFromEmail(email),
            initialEmail: email,
            initialAvatar: _avatarPath ?? 'assets/profil.png',
            onSave: (name, emailValue, avatar) async {
              setState(() {
                _displayName = name;
                _avatarPath = avatar;
              });
              await _saveProfile(name: name, avatarPath: avatar);
              
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('email', emailValue);
              
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil disimpan')));
            },
          ),
        ),
      ),
    );
  }



  String _displayNameFromEmail(String email) {
    if (email.isEmpty) return 'Guest';
    final local = email.split('@').first;
    if (local.isEmpty) return 'Guest';
    final parts = local.replaceAll(RegExp(r'[._]'), ' ').split(' ');
    final transformed = parts.map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}').join(' ');
    return transformed;
  }
}
