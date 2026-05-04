import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'auth_strings.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final pass = _passwordController.text;
    setState(() {
      _hasMinLength = pass.length >= 8;
      _hasUppercase = pass.contains(RegExp(r'[A-Z]'));
      _hasSpecialChar = pass.contains(RegExp(r'[!@#\$&*~]'));
    });
  }

  void _onSubmit() {
    final t = AuthStrings.of(context);
    if (!_hasMinLength || !_hasUppercase || !_hasSpecialChar) return;
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.passwordsMismatch)),
      );
      return;
    }

    final state = context.read<AuthBloc>().state;
    context.read<AuthBloc>().add(
          ResetPasswordRequested(
            phone: state.phoneNumber ?? '',
            newPassword: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
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
          if (state.status == AuthStatus.passwordReset) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 30),
                Text(
                  t.resetPasswordTitle,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.resetPasswordSubtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildLabel(t.newPassword, colorScheme),
                _buildTextField(
                  controller: _passwordController,
                  hint: t.strongPasswordHint,
                  obscureText: _obscurePassword,
                  onToggleObscure: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel(t.confirmNewPassword, colorScheme),
                _buildTextField(
                  controller: _confirmController,
                  hint: t.strongPasswordHint,
                  obscureText: _obscureConfirm,
                  onToggleObscure: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                ),
                const SizedBox(height: 16),
                _buildValidationRule(
                    t.minLengthRule, _hasMinLength, colorScheme),
                _buildValidationRule(
                    t.uppercaseRule, _hasUppercase, colorScheme),
                _buildValidationRule(
                    t.specialCharRule, _hasSpecialChar, colorScheme),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (state.status == AuthStatus.loading ||
                            !_hasMinLength ||
                            !_hasUppercase ||
                            !_hasSpecialChar)
                        ? null
                        : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: state.status == AuthStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            t.saveChange,
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: Text(
                    t.cancelProcess,
                    style: GoogleFonts.cairo(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text, ColorScheme colorScheme) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
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
    required bool obscureText,
    required VoidCallback onToggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: onToggleObscure,
        ),
        suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
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

  Widget _buildValidationRule(
    String text,
    bool isValid,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: isValid ? Colors.green : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}
