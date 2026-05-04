import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main_shell.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'auth_strings.dart';

class RegisterPatientPage extends StatefulWidget {
  const RegisterPatientPage({super.key});

  @override
  State<RegisterPatientPage> createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  void _onRegisterPressed() {
    final t = AuthStrings.of(context);
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.agreeTermsError)),
      );
      return;
    }

    context.read<AuthBloc>().add(
          RegisterPatientRequested(
            fullName: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AuthStrings.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.registerTitle,
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward
                : Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.registered) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainShell()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    t.patientWelcome,
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    t.patientRegisterSubtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                _buildLabel(t.fullName, colorScheme),
                _buildTextField(
                  controller: _nameController,
                  hint: t.fullNameHint,
                ),
                const SizedBox(height: 16),
                _buildLabel(t.phoneNumber, colorScheme),
                _buildTextField(
                  controller: _phoneController,
                  hint: '05xxxxxxxx',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildLabel(t.email, colorScheme),
                _buildTextField(
                  controller: _emailController,
                  hint: 'example@mail.com',
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon:
                      const Icon(Icons.email_outlined, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildLabel(t.password, colorScheme),
                _buildTextField(
                  controller: _passwordController,
                  hint: t.strongPasswordHint,
                  obscureText: _obscurePassword,
                  suffixIcon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                  prefixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel(t.confirmPassword, colorScheme),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hint: t.strongPasswordHint,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                  prefixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        onChanged: (val) {
                          setState(() => _agreeToTerms = val ?? false);
                        },
                        activeColor: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(text: t.termsPrefix),
                            TextSpan(
                              text: t.termsOfService,
                              style: GoogleFonts.cairo(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: t.andWord),
                            TextSpan(
                              text: t.privacyPolicy,
                              style: GoogleFonts.cairo(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: t.appSuffix),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.status == AuthStatus.loading
                        ? null
                        : _onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: state.status == AuthStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            t.registerTitle,
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.alreadyHaveAccount,
                      style: GoogleFonts.cairo(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        t.loginButton,
                        style: GoogleFonts.cairo(
                          color: colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
