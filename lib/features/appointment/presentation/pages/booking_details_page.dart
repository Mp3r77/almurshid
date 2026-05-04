import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/appointment_bloc.dart';
import 'doctor_details_page.dart';
import 'review_pay_page.dart';

enum BookingPeriod { morning, evening }

class BookingDetailsPage extends StatefulWidget {
  final dynamic doctor;
  final ConsultationType initialConsultationType;

  const BookingDetailsPage({
    super.key,
    required this.doctor,
    required this.initialConsultationType,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  ConsultationType _consultationType = ConsultationType.video;
  BookingPeriod _bookingPeriod = BookingPeriod.morning;
  String? _gender; // Will be initialized in didChangeDependencies

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gender ??= AppLocalizations.of(context)!.male;
  }

  @override
  void initState() {
    super.initState();
    _consultationType = widget.initialConsultationType;

    final selectedTime = context.read<AppointmentBloc>().state.selectedTime;
    if (selectedTime.contains('م') ||
        selectedTime.toLowerCase().contains('pm')) {
      _bookingPeriod = BookingPeriod.evening;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final basePrice =
        widget.doctor?.price is int ? widget.doctor.price as int : 3500;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.bookingDetails,
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_ios
                : Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _sectionHeader(Icons.person_outline, l10n.personalInfo),
              const SizedBox(height: 16),
              _buildTextField(
                label: l10n.fullName,
                hint: l10n.fullName,
                controller: _fullNameController,
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
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: [
                  AppLocalizations.of(context)!.male,
                  AppLocalizations.of(context)!.female
                ]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
              ),
              const SizedBox(height: 24),
              _sectionHeader(Icons.calendar_month_outlined, l10n.bookingDate),
              const SizedBox(height: 16),
              _buildCalendar(context),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.availableTime),
              const SizedBox(height: 12),
              BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  return _TimeSelector(
                    selectedTime: state.selectedTime,
                    onSelected: (time) =>
                        context.read<AppointmentBloc>().add(SelectTime(time)),
                  );
                },
              ),
              const SizedBox(height: 24),
              _sectionHeader(Icons.medical_services_outlined, 'نوع الحجز'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ChoiceCard(
                      title: l10n.onlineConsultation,
                      price: '$basePrice ر.ي',
                      icon: Icons.video_camera_back_outlined,
                      selected: _consultationType == ConsultationType.video,
                      onTap: () {
                        setState(() {
                          _consultationType = ConsultationType.video;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChoiceCard(
                      title: l10n.inPersonConsultation,
                      price: '${basePrice + 1000} ر.ي',
                      icon: Icons.add_home_work_outlined,
                      selected: _consultationType == ConsultationType.inPerson,
                      onTap: () {
                        setState(() {
                          _consultationType = ConsultationType.inPerson;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
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
          validator: (val) =>
              val == null || val.isEmpty ? 'هذا الحقل مطلوب' : null,
        ),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        final selectedDate = state.selectedDate;
        return Column(
          children: [
            Row(
              children: [
                Text(
                  intl.DateFormat('MMMM yyyy').format(selectedDate),
                  style: GoogleFonts.cairo(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null && context.mounted) {
                      context.read<AppointmentBloc>().add(SelectDate(picked));
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
                  final isSelected = selectedDate.day == date.day;
                  return GestureDetector(
                    onTap: () =>
                        context.read<AppointmentBloc>().add(SelectDate(date)),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        children: [
                          Text(
                            intl.DateFormat('E').format(date).substring(0, 1),
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
      },
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _goToPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00558A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.goToPayment,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.payments_outlined),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.totalPrice,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_bookingPriceFor(_consultationType)} ر.ي',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00558A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _goToPayment() {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appointmentState = context.read<AppointmentBloc>().state;
    if (appointmentState.selectedTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار الوقت أولاً')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPayPage(
          doctor: widget.doctor,
          bookingType: _consultationType == ConsultationType.video
              ? l10n.onlineConsultation
              : l10n.inPersonConsultation,
          price: _bookingPriceFor(_consultationType).toString(),
          patientName: _fullNameController.text.trim(),
          patientAge: _ageController.text.trim(),
          patientGender: _gender,
          patientPhone: _phoneController.text.trim(),
          bookingPeriod:
              _bookingPeriod == BookingPeriod.morning ? 'صباح' : 'مساء',
        ),
      ),
    );
  }

  int _bookingPriceFor(ConsultationType type) {
    final basePrice =
        widget.doctor?.price is int ? widget.doctor.price as int : 3500;
    return type == ConsultationType.video ? basePrice : basePrice + 1000;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String title;
  final String price;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.price,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00558A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected ? const Color(0xFF00558A) : colorScheme.outlineVariant,
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: const Color(0xFF00558A).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFF00558A),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              title,
              style: GoogleFonts.cairo(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: GoogleFonts.cairo(
                color: selected
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF00558A),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final String selectedTime;
  final ValueChanged<String> onSelected;

  const _TimeSelector({required this.selectedTime, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final times = [
      '09:00 ص',
      '10:00 ص',
      '11:00 ص',
      '01:00 م',
      '02:00 م',
      '03:00 م'
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: times.map((time) {
        final isSelected = selectedTime == time;
        return GestureDetector(
          onTap: () => onSelected(time),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF00558A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color:
                      isSelected ? const Color(0xFF00558A) : Colors.grey[200]!),
            ),
            child: Text(time,
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.black87)),
          ),
        );
      }).toList(),
    );
  }
}
