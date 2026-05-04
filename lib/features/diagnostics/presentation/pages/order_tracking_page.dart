import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/diagnostics_bloc.dart';
import '../bloc/diagnostics_state.dart';
import 'order_details_page.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagnosticsBloc, DiagnosticsState>(
      builder: (context, state) {
        final booking = state.currentBooking;
        if (booking == null) return const Scaffold(body: Center(child: Text('لا يوجد طلب')));

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'متابعة الطلب',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: booking.center.logoUrl ?? booking.center.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.biotech_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.center.name, 
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('22 أكتوبر 2023', style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(booking.patientName, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('ID: ${booking.id}', style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Additional Info Row (moved out of header to prevent overflow)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('10:30 صباحاً', style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                    const SizedBox(width: 4),
                    const Icon(Icons.access_time, size: 10, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text('الاثنين، 25 أكتوبر', style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                    const SizedBox(width: 4),
                    const Icon(Icons.calendar_month, size: 10, color: Colors.blue),
                  ],
                ),
                
                const SizedBox(height: 24),
                Text('مسار الطلب', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 20),
                
                // Stepper
                _buildStep(context, 'تم إرسال الطلب', 'تم استلام طلبك وبانتظار مراجعة المختبر', '10:30 ص', true, true),
                _buildStep(context, 'استلم المختبر الطلب', 'قام الفريق الطبي بالموافقة على استلام العينة', '11:15 ص', true, true),
                _buildStep(context, 'تم إرسال الطلب', 'تم استلام طلبك وبانتظار مراجعة المختبر', '10:30 ص', false, true),
                _buildStep(context, 'إرسال التسعيرة للمريض', 'سيتم إرسال رابط الدفع فور الانتهاء من التسعير', null, false, false),
                
                const SizedBox(height: 32),
                Text('تفاصيل الفحص المطلوبة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('صورة الروشتة المرفقة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                            Text('ملف PDF • 2.4 MB', style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.blue.withOpacity(0.1),
                        child: const Center(
                          child: Icon(Icons.description, size: 50, color: Colors.blue),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.visibility_outlined, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text('عرض بالحجم الكامل', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('الفحوصات المطلوبة', style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip('تحليل دم كامل - CBC'),
                    _chip('Vitamin D'),
                    _chip('الغدة الدرقية - TSH'),
                  ],
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00558A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('تفاصيل الموعد', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, String title, String subtitle, String? time, bool isCompleted, bool hasNext) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: isCompleted 
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Icon(Icons.image_outlined, color: Colors.orange[300], size: 18),
            ),
            if (hasNext)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: isCompleted ? Colors.black : Colors.grey))),
                  if (time != null) Text(time, style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
                ],
              ),
              Text(subtitle, style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: GoogleFonts.cairo(fontSize: 10)),
    );
  }
}
