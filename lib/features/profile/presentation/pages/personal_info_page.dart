import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/user_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'profile_page.dart';
import 'profile_strings.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthDateController;
  late String _selectedGender;
  late String _selectedBloodType;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserBloc>().state.user;
    final profileState = context.read<ProfileBloc>().state;

    _nameController = TextEditingController(text: user.fullName);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _birthDateController = TextEditingController(text: profileState.birthDate);
    _selectedGender = profileState.gender;
    _selectedBloodType = profileState.bloodType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = ProfileStrings.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t.personalInfoTitle,
          style: GoogleFonts.cairo(
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              final imageProvider = profileImageProvider(
                profileState.localProfileImage,
                userState.user.imageUrl,
              );

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: const Color(0xFFF7F0DB),
                              backgroundImage: imageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A5C97),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          t.changeProfilePhoto,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF243848),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _fieldLabel(t.fullNameField),
                        const SizedBox(height: 8),
                        _ProfileTextField(controller: _nameController),
                        const SizedBox(height: 14),
                        _fieldLabel(t.phoneField),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixText: '+966  ',
                        ),
                        const SizedBox(height: 14),
                        _fieldLabel(t.emailField),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        _fieldLabel(t.birthDateField),
                        const SizedBox(height: 8),
                        _ProfileTextField(
                          controller: _birthDateController,
                          suffixIcon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _SelectionField(
                                label: t.genderField,
                                value: _selectedGender,
                                options: const ['ذكر', 'أنثى'],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedGender = value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SelectionField(
                                label: t.bloodTypeField,
                                value: _selectedBloodType,
                                options: const [
                                  'A+',
                                  'A-',
                                  'B+',
                                  'B-',
                                  'O+',
                                  'O-',
                                  'AB+'
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedBloodType = value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _saveChanges,
                            icon:
                                const Icon(Icons.check_circle_outline_rounded),
                            label: Text(
                              t.saveChanges,
                              style: GoogleFonts.cairo(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A5C97),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(ProfileStrings.of(context).camera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(ProfileStrings.of(context).gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final file = await picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final savedPath =
        '${directory.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final bytes = await File(file.path).readAsBytes();
    await File(savedPath).writeAsBytes(bytes);

    if (!mounted) return;

    context.read<ProfileBloc>().add(UpdateProfileImage(savedPath));
    final currentUser = context.read<UserBloc>().state.user;
    context
        .read<UserBloc>()
        .add(UpdateUserEvent(currentUser.copyWith(imageUrl: savedPath)));
  }

  void _saveChanges() {
    final currentUser = context.read<UserBloc>().state.user;
    context.read<UserBloc>().add(
          UpdateUserEvent(
            currentUser.copyWith(
              fullName: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
            ),
          ),
        );
    context.read<ProfileBloc>().add(
          SavePersonalInfo(
            birthDate: _birthDateController.text.trim(),
            gender: _selectedGender,
            bloodType: _selectedBloodType,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ProfileStrings.of(context).profileSaved)),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF243848),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? prefixText;
  final IconData? suffixIcon;

  const _ProfileTextField({
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        prefixText: prefixText,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, size: 18, color: const Color(0xFF8B9BAA))
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FBFE),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFC9DBEC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0A5C97), width: 1.4),
        ),
      ),
    );
  }
}

class _SelectionField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _SelectionField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF243848),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FBFE),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFC9DBEC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF0A5C97), width: 1.4),
            ),
          ),
          items: options
              .map((item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
        ),
      ],
    );
  }
}
