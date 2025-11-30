import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _apiService = ApiService();
  final _picker = ImagePicker();
  bool _isLoading = false;
  DateTime? _selectedDate;
  XFile? _profileImage;

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = image;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _signup() async {
    setState(() => _isLoading = true);
    
    // For now, we'll use empty string if no profile image
    // TODO: Upload profile image to Backblaze first
    final success = await _apiService.register(
      _firstnameController.text,
      _lastnameController.text,
      _emailController.text,
      _passwordController.text,
      '', // Profile image URL (empty for now)
      _descriptionController.text,
      _selectedDate?.toIso8601String() ?? '',
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful! Please Login.')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB71C1C), // Deep Red
              Color(0xFF000000), // Black
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: _firstnameController,
                label: 'First Name',
              ),
              CustomTextField(
                controller: _lastnameController,
                label: 'Last Name',
              ),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
              ),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              // Profile Image Picker
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _profileImage == null
                                ? 'Profile Picture (optional)'
                                : 'Image selected: ${_profileImage!.name}',
                            style: TextStyle(
                              fontSize: 16,
                              color: _profileImage == null ? Colors.black54 : Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _pickProfileImage,
                          icon: const Icon(Icons.upload, size: 18),
                          label: Text(_profileImage == null ? 'Choose' : 'Change'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _profileImage != null ? Colors.green : const Color(0xFFB71C1C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description (optional)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Birthdate picker
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Birthdate (optional)'
                            : 'Birthdate: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null ? Colors.black54 : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Color(0xFFB71C1C)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Sign Up',
                onPressed: _signup,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
