import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:almurshid/features/appointment/presentation/pages/review_pay_page.dart';
import '../bloc/diagnostics_bloc.dart';
import '../bloc/diagnostics_state.dart';

class OrderDetailsPage extends StatelessWidget {
  final String? appointmentId;

  const OrderDetailsPage({super.key, this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagnosticsBloc, DiagnosticsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              l10n.bookingDetails,
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote Expiration Banner
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.quoteReceived,
                              style: GoogleFonts.cairo(
                                  color: Colors.white, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(l10n.quoteExpiryInfo,
                                  style: GoogleFonts.cairo(
                                      color: Colors.white, fontSize: 11))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Services List
                _buildServiceItem(
                    'فحص الرنين المغناطيسي (MRI)', 'تم الطلب في 24 مايو 2024'),
                _buildServiceItem('تصوير طبقي CT', 'تم الطلب في 24 مايو 2024'),
                _buildServiceItem(
                    'أشعة سينية X-Ray', 'تم الطلب في 24 مايو 2024'),

                const SizedBox(height: 24),
                Text(l10n.servicePrice,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _priceRow('فحص الرنين المغناطيسي (MRI)', '450.00 ر.س'),
                _priceRow('تصوير طبقي CT', '67.50 ر.س'),
                _priceRow('أشعة سينية X-Ray', '50.50 ر.س'),

                const SizedBox(height: 40),

                // Total Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('عرض نهائي',
                              style: GoogleFonts.cairo(
                                  color: Colors.blue, fontSize: 10)),
                        ),
                      ),
                      Text('السعر الإجمالي المطلوب',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        '12,000 ريال',
                        style: GoogleFonts.cairo(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00558A)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'يشمل هذا السعر كافة الفحوصات والصبغات المطلوبة ولا توجد أي رسوم مخفية عند الحضور للمركز.',
                          style: GoogleFonts.cairo(
                              fontSize: 10, color: Colors.blue[800]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close, color: Colors.red),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final booking = state.currentBooking;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewPayPage(
                                  lab: booking?.center,
                                  bookingType: 'حجز كشافة / أشعة',
                                  price: '12000',
                                  patientName: booking?.patientName,
                                  patientPhone: booking?.patientPhone,
                                  patientAge: booking?.patientAge.toString(),
                                  patientGender: booking?.patientGender,
                                  appointmentId: appointmentId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.payment, size: 20),
                          label: Text('تأكيد الحجز والدفع',
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00558A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.biotech_outlined, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                Text(subtitle,
                    style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(price,
              style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold, color: const Color(0xFF00558A))),
          Expanded(
              child: Text(label,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
