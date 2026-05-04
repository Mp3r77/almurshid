import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../bloc/diagnostics_bloc.dart';
import '../bloc/diagnostics_event.dart';
import '../bloc/diagnostics_state.dart';
import '../../../appointment/presentation/bloc/appointment_bloc.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import 'booking_success_page.dart';

class DiagnosticBookingPage extends StatefulWidget {
  const DiagnosticBookingPage({super.key});

  @override
  State<DiagnosticBookingPage> createState() => _DiagnosticBookingPageState();
}

class _DiagnosticBookingPageState extends State<DiagnosticBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final String _selectedTime = '10:30 صباحاً';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gender ??= AppLocalizations.of(context)!.male;
  }

  String? _attachedFileName;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<DiagnosticsBloc, DiagnosticsState>(
      listener: (context, state) {
        if (state.status == DiagnosticsStatus.bookingSuccess) {
          final center = state.currentBooking?.center;
          if (center != null) {
            final mappedDoctor = DoctorEntity(
              id: center.id,
              name: center.name,
              specialty: center.type.toString().contains('radiology')
                  ? 'مركز أشعة'
                  : 'مختبر طبي',
              location: center.location,
              bio: center.description ?? '',
              rating: double.tryParse(center.rating.toString()) ?? 0.0,
              reviews: center.reviewsCount,
              imageUrl: center.image,
              price: 12000,
            );

            context.read<AppointmentBloc>().add(
                  ProcessBooking(
                    doctorId: mappedDoctor.id,
                    dateTime: _selectedDate,
                    doctor: mappedDoctor,
                    bookingType: 'حجز كشافة / أشعة',
                    patientName: _nameController.text,
                    patientPhone: _phoneController.text,
                    patientGender: _gender,
                    patientAge: _ageController.text,
                    autoConfirm: false,
                  ),
                );
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BookingSuccessPage()),
          );
        }
        if (state.status == DiagnosticsStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ ما')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              l10n.diagnosticBookingTitle,
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Directionality.of(context) == ui.TextDirection.rtl
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(Icons.person_outline, l10n.personalInfo),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: l10n.fullName,
                    hint: l10n.fullName,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: l10n.phone,
                          hint: '05xxxxxxxx',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: l10n.age,
                          hint: '25',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.gender,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    items: [
                      AppLocalizations.of(context)!.male,
                      AppLocalizations.of(context)!.female
                    ]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                  const SizedBox(height: 24),
                  _sectionHeader(Icons.image_outlined, l10n.uploadPrescription),
                  const SizedBox(height: 16),
                  _buildUploadSection(context),
                  const SizedBox(height: 24),
                  _sectionHeader(
                      Icons.calendar_month_outlined, l10n.bookingDate),
                  const SizedBox(height: 16),
                  _buildCalendar(context),
                  const SizedBox(height: 32),

                  // Info Alert
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Colors.blue, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.pricingInfo,
                            style: GoogleFonts.cairo(
                                fontSize: 12, color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed:
                          state.status == DiagnosticsStatus.bookingSubmitting
                              ? null
                              : () => _submitBooking(context),
                      icon: state.status == DiagnosticsStatus.bookingSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send),
                      label: Text(
                        l10n.submitForPricing,
                        style: GoogleFonts.cairo(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (val) => val == null || val.isEmpty
              ? AppLocalizations.of(context)!.fieldRequired
              : null,
        ),
      ],
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'pdf'],
        );

        if (result != null) {
          setState(() {
            _attachedFileName = result.files.single.name;
          });
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: Colors.blue.withOpacity(0.2), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                _attachedFileName == null
                    ? Icons.add_photo_alternate_outlined
                    : Icons.check_circle_outline,
                color: Colors.blue,
                size: 40),
            const SizedBox(height: 8),
            Text(
              _attachedFileName ?? l10n.tapToUpload,
              style: GoogleFonts.cairo(
                  color: Colors.blue, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (_attachedFileName == null)
              Text(
                l10n.maxFileSize,
                style: GoogleFonts.cairo(color: Colors.grey, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style:
                  GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.calendar_month,
                    color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.list, color: Colors.grey, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: List.generate(7, (index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = _selectedDate.day == date.day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('E').format(date).substring(0, 1),
                        style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${date.day}',
                        style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(Icons.person_outline, color: Colors.grey),
          const Icon(Icons.favorite_border, color: Colors.grey),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.home_outlined, color: Colors.blue),
          ),
          const Icon(Icons.calendar_month_outlined, color: Colors.grey),
          const Icon(Icons.person_pin_circle_outlined, color: Colors.grey),
        ],
      ),
    );
  }

  void _submitBooking(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      context.read<DiagnosticsBloc>().add(SubmitBookingRequest(
            patientName: _nameController.text,
            patientPhone: _phoneController.text,
            patientAge: int.parse(_ageController.text),
            patientGender: _gender ?? l10n.male,
            appointmentDate: _selectedDate,
            appointmentTime: _selectedTime,
          ));
    }
  }
}
