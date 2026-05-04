import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/diagnostic_entities.dart';
import 'diagnostic_booking_page.dart';
import '../../../reviews/presentation/pages/add_review_page.dart';
import '../../../../core/widgets/full_screen_image_page.dart';

class DiagnosticCenterProfilePage extends StatelessWidget {
  final DiagnosticCenter center;

  const DiagnosticCenterProfilePage({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildHeader(context, colorScheme),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            _buildTitleSection(colorScheme),
                            _buildStatsRow(colorScheme),
                            _buildTabBar(colorScheme),
                            SizedBox(
                              height: 600, // Fixed height for tab content
                              child: TabBarView(
                                children: [
                                  _buildAboutTab(context, colorScheme),
                                  _buildLocationTab(context, colorScheme),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomButton(context, colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: const Icon(Icons.share_outlined, color: Colors.black, size: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: const Icon(Icons.favorite_border, color: Colors.black, size: 20),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => FullScreenImagePage.show(
                  context,
                  center.image,
                  tag: 'center_image_${center.id}',
                ),
                child: Hero(
                  tag: 'center_image_${center.id}',
                  child: CachedNetworkImage(
                    imageUrl: center.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: GestureDetector(
                    onTap: () => FullScreenImagePage.show(
                      context,
                      center.logoUrl ?? center.image,
                      tag: 'center_logo_${center.id}',
                    ),
                    child: Hero(
                      tag: 'center_logo_${center.id}',
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: center.logoUrl ?? center.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Icon(Icons.business),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
      child: Column(
        children: [
          Text(
            center.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003D66),
            ),
          ),
          Text(
            center.type == DiagnosticType.radiology
                ? 'مركز تشخيصي متكامل التخصص'
                : 'مختبر تحاليل طبية متكامل',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(center.rating, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${center.reviewsCount} تقييم',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.green, size: 18),
                  const SizedBox(width: 4),
                  Text('مفتوح الآن',
                      style: GoogleFonts.cairo(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('يغلق 10:00 م', style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text(center.distance,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
              Text('اليمن، صنعاء', style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: TabBar(
        labelColor: Colors.blue[900],
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue[900],
        indicatorWeight: 3,
        labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        tabs: const [Tab(text: 'نبذة'), Tab(text: 'الموقع')],
      ),
    );
  }

  Widget _buildAboutTab(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('نبذة عن المركز', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Text(center.description ?? '', style: GoogleFonts.cairo(color: Colors.grey[700], height: 1.6)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('آراء المرضى', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton.icon(
                onPressed: () {
                  AddReviewPage.show(
                    context,
                    targetId: center.id,
                    targetName: center.name,
                    targetImageUrl: center.logoUrl ?? center.image,
                    targetSubtitle: center.type == DiagnosticType.radiology
                        ? 'مركز تشخيصي متكامل التخصص'
                        : 'مختبر تحاليل طبية متكامل',
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: Text('إضافة تقييم', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF00558A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(center.rating, style: GoogleFonts.cairo(fontSize: 48, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 16)),
                    ),
                    Text('${center.reviewsCount} تقييم', style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.8),
                    _buildRatingBar(4, 0.6),
                    _buildRatingBar(3, 0.3),
                    _buildRatingBar(2, 0.1),
                    _buildRatingBar(1, 0.05),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star', style: GoogleFonts.cairo(fontSize: 12)),
          const SizedBox(width: 8),
          const Icon(Icons.star, color: Colors.orange, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF00558A),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(15.3694, 44.1910),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.almurshid.app',
              ),
              const MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(15.3694, 44.1910),
                    width: 80,
                    height: 80,
                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiagnosticBookingPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00558A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            center.type == DiagnosticType.radiology ? 'طلب حجز كشافة/أشعة' : 'طلب فحص مخبري',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
