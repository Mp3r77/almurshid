import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/appointment_bloc.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import 'booking_success_page.dart';

enum _PaymentMethod { wallet, exchangeTransfer }

class ReviewPayPage extends StatefulWidget {
  final dynamic doctor;
  final dynamic lab;
  final String? bookingType;
  final String? price;
  final String? patientName;
  final String? patientAge;
  final String? patientGender;
  final String? patientPhone;
  final String? bookingPeriod;
  final String? appointmentId;

  const ReviewPayPage({
    super.key,
    this.doctor,
    this.lab,
    this.bookingType,
    this.price,
    this.patientName,
    this.patientAge,
    this.patientGender,
    this.patientPhone,
    this.bookingPeriod,
    this.appointmentId,
  });

  @override
  State<ReviewPayPage> createState() => _ReviewPayPageState();
}

class _ReviewPayPageState extends State<ReviewPayPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<_WalletInfo> _wallets = const [
    _WalletInfo(
      name: 'زين كاش',
      accountNumber: '777123456',
      icon: Icons.phone_android_rounded,
    ),
    _WalletInfo(
      name: 'إم فلوس',
      accountNumber: '771234567',
      icon: Icons.account_balance_wallet_rounded,
    ),
  ];

  static const _ExchangeInfo _exchangeInfo = _ExchangeInfo(
    adminFullName: 'محمد عبدالسلام أحمد',
    phoneNumber: '770123456',
  );

  _PaymentMethod _paymentMethod = _PaymentMethod.wallet;
  final List<String> attachments = [];
  XFile? _paymentProof;
  bool _awaitingPaymentReview = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final appointmentState = context.watch<AppointmentBloc>().state;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.bookingDetails,
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward_ios
                  : Icons.arrow_back_ios,
              color: colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: BlocConsumer<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state.status == AppointmentStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تعذر تأكيد الحجز. حاول مرة أخرى.')),
            );
          }

          if (state.status == AppointmentStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'تم تأكيد الدفع وإتمام الحجز، وتم إرسال إشعار للمستخدم.'),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BookingSuccessPage(
                  doctor: widget.doctor ?? widget.lab,
                  bookingType: widget.bookingType,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _DoctorMiniHeader(doctor: widget.doctor, lab: widget.lab),
                const SizedBox(height: 20),
                _labelText(context, l10n.patientInformation),
                const SizedBox(height: 10),
                _PatientInfoCard(
                  patientName: widget.patientName ?? 'اسم المريض',
                  patientAge: widget.patientAge,
                  patientGender: widget.patientGender,
                  patientPhone: widget.patientPhone,
                  bookingPeriod: widget.bookingPeriod,
                  attachments: attachments,
                  onUploadAttachment: _addAttachment,
                ),
                const SizedBox(height: 24),
                _labelText(context, l10n.bookingDate),
                const SizedBox(height: 10),
                _InfoTile(
                  icon: Icons.calendar_today,
                  title:
                      '${appointmentState.selectedDate.day}/${appointmentState.selectedDate.month}/${appointmentState.selectedDate.year}',
                  subtitle: appointmentState.selectedTime.isEmpty
                      ? 'لم يتم اختيار وقت'
                      : appointmentState.selectedTime,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 24),
                _labelText(context, l10n.bookingType),
                const SizedBox(height: 10),
                _InfoTile(
                  icon: Icons.video_camera_back,
                  title: widget.bookingType ?? 'موعد إلكتروني',
                  subtitle: '${widget.price ?? "3,500"} ريال',
                  trailing: Icons.monetization_on,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 24),
                _labelText(context, 'اختر وسيلة الدفع'),
                const SizedBox(height: 10),
                _PaymentMethodPicker(
                  selectedMethod: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 18),
                _PaymentInstructionsCard(
                  paymentMethod: _paymentMethod,
                  wallets: _wallets,
                  exchangeInfo: _exchangeInfo,
                ),
                const SizedBox(height: 24),
                _labelText(context, 'رفع صورة التحويل'),
                const SizedBox(height: 10),
                _PaymentProofCard(
                  paymentProof: _paymentProof,
                  onTap: _pickPaymentProof,
                ),
                const SizedBox(height: 14),
                const _TransferNotice(),
                if (_awaitingPaymentReview) ...[
                  const SizedBox(height: 16),
                  const _AwaitingReviewCard(),
                ],
                const SizedBox(height: 24),
                _SubmitTransferButton(
                  status: state.status,
                  awaitingReview: _awaitingPaymentReview,
                  onPressed: _submitTransferConfirmation,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _labelText(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  void _addAttachment() {
    setState(() {
      attachments.add('مرفق ${attachments.length + 1}.pdf');
    });
  }

  Future<void> _pickPaymentProof() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('اختيار من المعرض'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('التقاط صورة'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    final file = await _imagePicker.pickImage(source: source, imageQuality: 85);

    if (!mounted || file == null) {
      return;
    }

    setState(() {
      _paymentProof = file;
      _awaitingPaymentReview = false;
    });
  }

  Future<void> _submitTransferConfirmation() async {
    if (_paymentProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أرفق صورة إشعار التحويل أولاً.')),
      );
      return;
    }

    setState(() {
      _awaitingPaymentReview = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('تم إرسال إشعار التحويل، بانتظار تأكيد الدفع من الإدارة.'),
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    final appointmentState = context.read<AppointmentBloc>().state;
    final mappedDoctor = widget.doctor ??
        (widget.lab != null
            ? DoctorEntity(
                id: widget.lab.id,
                name: widget.lab.name,
                specialty: widget.lab.type.toString().contains('radiology')
                    ? 'مركز أشعة'
                    : 'مختبر طبي',
                location: widget.lab.location,
                bio: widget.lab.description,
                rating: double.tryParse(widget.lab.rating.toString()) ?? 0.0,
                reviews: widget.lab.reviewsCount,
                imageUrl: widget.lab.image,
                price: 12000,
              )
            : null);

    if (widget.appointmentId != null && widget.appointmentId!.isNotEmpty) {
      context
          .read<AppointmentBloc>()
          .add(ConfirmPendingAppointment(widget.appointmentId!));
    } else {
      context.read<AppointmentBloc>().add(
            ProcessBooking(
              doctorId: mappedDoctor?.id ?? 'lab_booking',
              dateTime: _resolveAppointmentDateTime(appointmentState),
              doctor: mappedDoctor,
              bookingType: widget.bookingType,
              patientName: widget.patientName,
              patientPhone: widget.patientPhone,
              patientGender: widget.patientGender,
              patientAge: widget.patientAge,
              bookingPeriod: widget.bookingPeriod,
            ),
          );
    }
  }

  DateTime _resolveAppointmentDateTime(AppointmentState state) {
    final selectedDate = state.selectedDate;
    final selectedTime = state.selectedTime.trim();

    if (selectedTime.isEmpty) {
      return selectedDate;
    }

    final normalized = selectedTime
        .replaceAll('ص', 'AM')
        .replaceAll('م', 'PM')
        .replaceAll(' ', '');

    final parts = normalized.split(RegExp('[: ]'));
    if (parts.length < 2) {
      return selectedDate;
    }

    final timePart = parts[0];
    final periodPart = parts[1];
    final clock = timePart.split(':');
    if (clock.length != 2) {
      return selectedDate;
    }

    var hour = int.tryParse(clock[0]) ?? 0;
    final minute = int.tryParse(clock[1]) ?? 0;

    if (periodPart.toUpperCase() == 'PM' && hour < 12) {
      hour += 12;
    } else if (periodPart.toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );
  }
}

class _DoctorMiniHeader extends StatelessWidget {
  final dynamic doctor;
  final dynamic lab;

  const _DoctorMiniHeader({this.doctor, this.lab});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              doctor?.imageUrl ??
                  'https://cdn-icons-png.flaticon.com/512/3063/3063176.png',
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          doctor?.name ?? lab?.name ?? 'المركز الطبي',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          doctor?.specialty ?? 'فحص طبي',
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PatientInfoCard extends StatelessWidget {
  final String patientName;
  final String? patientAge;
  final String? patientGender;
  final String? patientPhone;
  final String? bookingPeriod;
  final List<String> attachments;
  final VoidCallback onUploadAttachment;

  const _PatientInfoCard({
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientPhone,
    required this.bookingPeriod,
    required this.attachments,
    required this.onUploadAttachment,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            patientName,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              if (patientAge != null && patientAge!.isNotEmpty)
                _PatientMetaChip(label: 'العمر: $patientAge'),
              if (patientGender != null && patientGender!.isNotEmpty)
                _PatientMetaChip(label: 'الجنس: $patientGender'),
              if (patientPhone != null && patientPhone!.isNotEmpty)
                _PatientMetaChip(label: 'الهاتف: $patientPhone'),
              if (bookingPeriod != null && bookingPeriod!.isNotEmpty)
                _PatientMetaChip(label: 'الفترة: $bookingPeriod'),
            ],
          ),
          if (attachments.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: attachments
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      avatar: const Icon(Icons.description_outlined, size: 18),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: onUploadAttachment,
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('إضافة مرفق'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientMetaChip extends StatelessWidget {
  final String label;

  const _PatientMetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final IconData? trailing;
  final VoidCallback onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.edit_outlined, color: colorScheme.primary, size: 24),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Icon(trailing ?? icon, color: colorScheme.primary, size: 24),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodPicker extends StatelessWidget {
  final _PaymentMethod selectedMethod;
  final ValueChanged<_PaymentMethod> onChanged;

  const _PaymentMethodPicker({
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PaymentMethodChip(
              label: 'حوالة صراف',
              icon: Icons.compare_arrows_rounded,
              selected: selectedMethod == _PaymentMethod.exchangeTransfer,
              onTap: () => onChanged(_PaymentMethod.exchangeTransfer),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _PaymentMethodChip(
              label: 'دفع عبر محفظة',
              icon: Icons.account_balance_wallet_outlined,
              selected: selectedMethod == _PaymentMethod.wallet,
              onTap: () => onChanged(_PaymentMethod.wallet),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.cairo(
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentInstructionsCard extends StatelessWidget {
  final _PaymentMethod paymentMethod;
  final List<_WalletInfo> wallets;
  final _ExchangeInfo exchangeInfo;

  const _PaymentInstructionsCard({
    required this.paymentMethod,
    required this.wallets,
    required this.exchangeInfo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            paymentMethod == _PaymentMethod.wallet
                ? 'المحافظ اليمنية المتاحة'
                : 'بيانات حوالة الصراف',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (paymentMethod == _PaymentMethod.wallet)
            ...wallets.map(
              (wallet) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _InfoOptionTile(
                  title: wallet.name,
                  subtitle: 'رقم الحساب: ${wallet.accountNumber}',
                  icon: wallet.icon,
                ),
              ),
            )
          else
            _InfoOptionTile(
              title: exchangeInfo.adminFullName,
              subtitle: 'رقم التلفون: ${exchangeInfo.phoneNumber}',
              icon: Icons.support_agent_rounded,
            ),
        ],
      ),
    );
  }
}

class _InfoOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _InfoOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorScheme.primary.withOpacity(0.12),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentProofCard extends StatelessWidget {
  final XFile? paymentProof;
  final VoidCallback onTap;

  const _PaymentProofCard({
    required this.paymentProof,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colorScheme.primary.withOpacity(0.35)),
        ),
        child: paymentProof == null
            ? Column(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 42,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'اضغط لرفع صورة الإشعار',
                    style: GoogleFonts.cairo(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'يدعم JPG و PNG',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(paymentProof!.path),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    paymentProof!.name,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'اضغط لتغيير الصورة المرفقة',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TransferNotice extends StatelessWidget {
  const _TransferNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'يرجى التأكد من وضوح صورة الإشعار. بعد تأكيد التحويل من الإدارة سيصلك إشعار بإتمام عملية الحجز.',
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AwaitingReviewCard extends StatelessWidget {
  const _AwaitingReviewCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'تم إرسال التحويل للمراجعة. انتظر حتى يتم تأكيد الدفع ثم سيتم إتمام الحجز.',
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitTransferButton extends StatelessWidget {
  final AppointmentStatus status;
  final bool awaitingReview;
  final VoidCallback onPressed;

  const _SubmitTransferButton({
    required this.status,
    required this.awaitingReview,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: status == AppointmentStatus.loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: status == AppointmentStatus.loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.4,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  awaitingReview ? 'جاري تأكيد التحويل' : 'تأكيد التحويل',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.send_outlined),
              ],
            ),
    );
  }
}

class _WalletInfo {
  final String name;
  final String accountNumber;
  final IconData icon;

  const _WalletInfo({
    required this.name,
    required this.accountNumber,
    required this.icon,
  });
}

class _ExchangeInfo {
  final String adminFullName;
  final String phoneNumber;

  const _ExchangeInfo({
    required this.adminFullName,
    required this.phoneNumber,
  });
}
