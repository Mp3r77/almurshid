import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'booking_details_page.dart';
import '../../../reviews/presentation/pages/add_review_page.dart';
import '../../../../core/widgets/full_screen_image_page.dart';

enum ConsultationType { video, inPerson }

class DoctorDetailsPage extends StatefulWidget {
  final dynamic doctor;

  const DoctorDetailsPage({super.key, this.doctor});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  ConsultationType selectedType = ConsultationType.video;

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
            child:
                const Icon(Icons.share_outlined, color: Colors.black, size: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: const Icon(Icons.favorite_border,
                color: Colors.black, size: 20),
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
                  'https://images.unsplash.com/photo-1628348068343-c6a848d2b6dd?q=80&w=1470&auto=format&fit=crop',
                  tag: 'doctor_cover',
                ),
                child: Hero(
                  tag: 'doctor_cover',
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1628348068343-c6a848d2b6dd?q=80&w=1470&auto=format&fit=crop', // Doctor office cover
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
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
                      widget.doctor?.imageUrl ??
                          'https://i.pravatar.cc/150?img=32',
                      tag: 'doctor_profile',
                    ),
                    child: Hero(
                      tag: 'doctor_profile',
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.doctor?.imageUrl ??
                              'https://i.pravatar.cc/150?img=32',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Icon(Icons.person),
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
            widget.doctor?.name ?? 'د. لمياء الأهدل',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003D66),
            ),
          ),
          Text(
            widget.doctor?.specialty ?? 'طبيبة أطفال',
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
    final l10n = AppLocalizations.of(context)!;

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
                  Text(widget.doctor?.rating?.toStringAsFixed(1) ?? '4.8',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${widget.doctor?.reviews ?? 0} ${l10n.reviews}',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.green, size: 18),
                  const SizedBox(width: 4),
                  Text(l10n.availableNow,
                      style: GoogleFonts.cairo(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${l10n.closesAt} 08:00 ${l10n.evening}',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text('2.5 ${l10n.km}',
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
              Text(widget.doctor?.location ?? 'عدن',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: TabBar(
        labelColor: Colors.blue[900],
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue[900],
        indicatorWeight: 3,
        labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        tabs: [Tab(text: l10n.about), Tab(text: l10n.locationTab)],
      ),
    );
  }

  Widget _buildAboutTab(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.aboutDoctorTitle,
              style:
                  GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Text(
              widget.doctor?.bio ??
                  'طبيب متخصص يقدم استشارات طبية ومتابعة دورية وخطة علاج مناسبة لكل حالة.',
              style: GoogleFonts.cairo(color: Colors.grey[700], height: 1.6)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.patientReviews,
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton.icon(
                onPressed: () {
                  AddReviewPage.show(
                    context,
                    targetId: widget.doctor?.id?.toString() ?? '1',
                    targetName: widget.doctor?.name ?? 'د. لمياء الأهدل',
                    targetImageUrl: widget.doctor?.imageUrl,
                    targetSubtitle: widget.doctor?.specialty ?? 'طبيبة أطفال',
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addReviewButton,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF00558A),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReviewItem('أحمد صالح', 5.0,
              'طبيبة ممتازة جداً وصبورة في التعامل مع الأطفال.', 'قبل يومين'),
          const SizedBox(height: 12),
          _buildReviewItem('سارة خالد', 4.0,
              'تشخيص دقيق ومعاملة راقية، شكراً جزيلاً.', 'قبل أسبوع'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      String name, double rating, String comment, String date) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
              Text(name,
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
                5,
                (index) => Icon(index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange, size: 16)),
          ),
          const SizedBox(height: 8),
          Text(comment,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[700])),
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
              initialCenter: LatLng(12.8000, 45.0333), // Aden
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
                    point: LatLng(12.8000, 45.0333),
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailsPage(
                  doctor: widget.doctor,
                  initialConsultationType: selectedType,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00558A),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            l10n.bookNowButton,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
