import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';

class AddReviewPage extends StatefulWidget {
  final String targetId;
  final String targetName;
  final String? targetImageUrl;
  final String? targetSubtitle;

  const AddReviewPage({
    super.key,
    required this.targetId,
    required this.targetName,
    this.targetImageUrl,
    this.targetSubtitle,
  });

  static void show(
    BuildContext context, {
    required String targetId,
    required String targetName,
    String? targetImageUrl,
    String? targetSubtitle,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReviewPage(
        targetId: targetId,
        targetName: targetName,
        targetImageUrl: targetImageUrl,
        targetSubtitle: targetSubtitle,
      ),
    );
  }

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state.status == ReviewStatus.submitSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال التقييم بنجاح')),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  'تقييم الخدمة',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Target Info
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: widget.targetImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.targetImageUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: Colors.blue[50],
                      child: const Icon(Icons.person, size: 60, color: Colors.blue),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.targetName,
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF003D66),
              ),
            ),
            if (widget.targetSubtitle != null)
              Text(
                widget.targetSubtitle!,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

            const SizedBox(height: 40),
            Text(
              'كيف كانت تجربتك؟',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'رأيك يهمنا لتحسين جودة الرعاية الطبية المقدمة لك دائماً',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.orange : Colors.grey[300],
                    size: 40,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'أضف تعليقك (اختياري)',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب تجربتك هنا بالتفصيل...',
                hintStyle: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue[100]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue[100]!),
                ),
              ),
            ),

            const Spacer(),

            // Actions
            BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: state.status == ReviewStatus.submitting
                        ? null
                        : () {
                            if (_rating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('يرجى اختيار التقييم أولاً')),
                              );
                              return;
                            }
                            context.read<ReviewBloc>().add(
                                  SubmitReview(
                                    targetId: widget.targetId,
                                    rating: _rating,
                                    comment: _commentController.text,
                                    targetName: widget.targetName,
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00558A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.status == ReviewStatus.submitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'إرسال التقييم',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'تخطي',
                style: GoogleFonts.cairo(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
