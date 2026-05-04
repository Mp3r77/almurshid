import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'provider_status_page.dart';

class RegisterProviderPage extends StatefulWidget {
  final bool isLab;

  const RegisterProviderPage({super.key, required this.isLab});

  @override
  State<RegisterProviderPage> createState() => _RegisterProviderPageState();
}

class _RegisterProviderPageState extends State<RegisterProviderPage> {
  int _currentStep = 0;

  // Step 1 Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();

  // Step 2 Files
  String? _licenseFileName;
  String? _licenseFilePath;
  String? _idFileName;
  String? _idFilePath;

  Future<void> _pickLicenseFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _licenseFilePath = result.files.single.path;
        _licenseFileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickIdFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _idFilePath = result.files.single.path;
        _idFileName = result.files.single.name;
      });
    }
  }

  void _submit() {
    context.read<AuthBloc>().add(
          RegisterProviderRequested(
            fullName: _nameController.text,
            phone: _phoneController.text,
            specialty: _specialtyController.text,
            licenseFilePath: _licenseFilePath ?? '',
            idFilePath: _idFilePath ?? '',
            isLab: widget.isLab,
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = widget.isLab ? 'إنشاء حساب مختبر' : 'إنشاء حساب طبيب';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: GoogleFonts.cairo(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_forward, color: colorScheme.onSurface),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.providerPendingApproval ||
                state.status == AuthStatus.providerRejected) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProviderStatusPage()),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildStepperHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: _currentStep == 0
                        ? _buildStep1(context)
                        : _currentStep == 1
                            ? _buildStep2(context, state)
                            : _buildStep3(context, state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepperHeader(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final inactive = Colors.grey.shade300;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
      child: Row(
        children: [
          _buildStepIndicator(1, 'البيانات', true, primary),
          Expanded(
              child: Container(
                  height: 2, color: _currentStep >= 1 ? primary : inactive)),
          _buildStepIndicator(2, 'التوثيق', _currentStep >= 1,
              _currentStep >= 1 ? primary : inactive),
          Expanded(
              child: Container(
                  height: 2, color: _currentStep >= 2 ? primary : inactive)),
          _buildStepIndicator(3, 'المراجعة', _currentStep >= 2,
              _currentStep >= 2 ? primary : inactive),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
      int stepNumber, String label, bool isActive, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Text(
            '$stepNumber',
            style: GoogleFonts.cairo(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 10,
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  Widget _buildStep1(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البيانات الشخصية',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('الاسم الكامل (كما في الهوية)', colorScheme),
              _buildTextField(
                controller: _nameController,
                hint: 'أحمد محمد القباطي',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              _buildLabel('رقم الهاتف', colorScheme),
              _buildTextField(
                controller: _phoneController,
                hint: '+967776719456',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: 16),
              _buildLabel(
                  widget.isLab ? 'التخصص الطبي للمختبر' : 'التخصص الطبي',
                  colorScheme),
              _buildTextField(
                controller: _specialtyController,
                hint: widget.isLab
                    ? 'مختبرات تحاليل طبية'
                    : 'استشاري أمراض القلب',
                prefixIcon: const Icon(Icons.medical_information_outlined),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'التالي',
              style:
                  GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context, AuthState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الوثائق المهنية',
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'يرجى إرفاق الوثائق التالية لإتمام عملية التوثيق',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              _buildDocUploader(
                context: context,
                title: widget.isLab ? 'ترخيص المختبر' : 'شهادة مزاولة المهنة',
                subtitle: 'PDF, JPG (حد أقصى 5 MB)',
                icon: Icons.workspace_premium_outlined,
                fileName: _licenseFileName,
                onTap: _pickLicenseFile,
              ),
              const SizedBox(height: 16),
              _buildDocUploader(
                context: context,
                title: 'الهوية الوطنية / الإقامة',
                subtitle: 'PDF, JPG (حد أقصى 5 MB)',
                icon: Icons.badge_outlined,
                fileName: _idFileName,
                onTap: _pickIdFile,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border.all(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نظام التدقيق المهني',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سيتم مراجعة طلبك من قبل الفريق المختص خلال 24-48 ساعة عمل. تأكد من وضوح البيانات المرفوعة لتسريع عملية التوثيق.',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 0;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'السابق',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'التالي',
                  style: GoogleFonts.cairo(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3(BuildContext context, AuthState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مراجعة البيانات',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Personal Data Section
        Text(
          'البيانات الشخصية',
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        _buildReviewItem('الاسم الكامل', _nameController.text),
        _buildReviewItem('رقم الهاتف', _phoneController.text),
        _buildReviewItem(widget.isLab ? 'التخصص الطبي للمختبر' : 'التخصص الطبي',
            _specialtyController.text),
        const SizedBox(height: 16),

        // Documents Section
        Text(
          'الوثائق المهنية',
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        _buildReviewItem(widget.isLab ? 'ترخيص المختبر' : 'شهادة مزاولة المهنة',
            _licenseFileName ?? 'لم يتم رفع الملف'),
        _buildReviewItem(
            'الهوية الوطنية / الإقامة', _idFileName ?? 'لم يتم رفع الملف'),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            border: Border.all(color: Colors.orange.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نظام التدقيق المهني',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سيتم مراجعة طلبك من قبل الفريق المختص خلال 24-48 ساعة عمل. تأكد من وضوح البيانات المرفوعة لتسريع عملية التوثيق.',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'السابق',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: state.status == AuthStatus.loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: state.status == AuthStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تقديم الطلب',
                            style: GoogleFonts.cairo(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle_outline),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocUploader({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUploaded = fileName != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isUploaded ? colorScheme.primary.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isUploaded ? colorScheme.primary : Colors.grey.shade300,
            style: isUploaded
                ? BorderStyle.solid
                : BorderStyle.solid, // Dash borders in real app if desired
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isUploaded
                  ? colorScheme.primary.withOpacity(0.2)
                  : Colors.grey.shade100,
              child: Icon(
                icon,
                color: isUploaded ? colorScheme.primary : Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isUploaded ? fileName : title,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isUploaded ? colorScheme.primary : colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isUploaded)
              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isUploaded ? colorScheme.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isUploaded ? 'تم الرفع بنجاح' : 'رفع الوثيقة',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUploaded ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: prefixIcon,
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
