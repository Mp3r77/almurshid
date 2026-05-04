import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/locale/locale_extensions.dart';
import '../../../appointment/presentation/pages/doctor_details_page.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import '../../../doctors/presentation/bloc/doctors_bloc.dart';
import '../../../doctors/presentation/bloc/doctors_state.dart';
import '../bloc/diagnosis_bloc.dart';
import '../bloc/diagnosis_state.dart';

class SmartDiagnosisResultsPage extends StatelessWidget {
  const SmartDiagnosisResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('نتائج التشخيص', 'Diagnosis Results'),
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<DiagnosisBloc, DiagnosisState>(
        builder: (context, diagnosisState) {
          return BlocBuilder<DoctorsBloc, DoctorsState>(
            builder: (context, doctorsState) {
              final recommendedDoctors = _recommendedDoctors(
                doctorsState,
                diagnosisState,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DiagnosisResultCard(state: diagnosisState),
                    const SizedBox(height: 18),
                    _DoctorsSection(
                      diagnosisState: diagnosisState,
                      doctorsState: doctorsState,
                      doctors: recommendedDoctors,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DiagnosisResultCard extends StatelessWidget {
  final DiagnosisState state;

  const _DiagnosisResultCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Icon(Icons.share_outlined, size: 18, color: colorScheme.primary),
              const Spacer(),
              Text(
                context.tr('نتائج التشخيص', 'Diagnosis Results'),
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: colorScheme.onSurface),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('التحليل الأولي للأعراض', 'Initial Symptom Analysis'),
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 138,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEAF4FF),
                  Color(0xFFD8EBFA),
                  Color(0xFFF4F8FC)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(child: _MedicalArtwork()),
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('نتيجة التشخيص الذكي', 'Smart Diagnosis Result'),
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.diagnosisTitle,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.diagnosisSubtitle,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
          if (state.specialties.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: state.specialties
                  .map(
                    (specialty) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        specialty,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _DoctorsSection extends StatelessWidget {
  final DiagnosisState diagnosisState;
  final DoctorsState doctorsState;
  final List<DoctorEntity> doctors;

  const _DoctorsSection({
    required this.diagnosisState,
    required this.doctorsState,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                   // Navigate to all doctors if needed
                },
                child: Text(
                  context.tr('عرض الكل', 'View All'),
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              Text(
                context.tr('الأطباء المقترحون', 'Recommended Doctors'),
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            diagnosisState.specialties.isEmpty
                ? context.tr(
                    'عرضنا لك الأطباء المتاحين حاليًا.',
                    'Showing currently available doctors.',
                  )
                : context.tr(
                    'تم اختيار هؤلاء الأطباء بناءً على التخصصات: ${diagnosisState.specialties.join('، ')}',
                    'These doctors were selected based on the specialties: ${diagnosisState.specialties.join(', ')}',
                  ),
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          if (doctorsState.status == DoctorsStatus.loading)
            const Center(child: CircularProgressIndicator())
          else if (doctors.isEmpty)
            Text(
              context.tr(
                'لا يوجد أطباء مطابقون لهذه الحالة حاليًا.',
                'No doctors match this condition right now.',
              ),
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...doctors.map((doctor) => _DiagnosisDoctorCard(doctor: doctor)),
        ],
      ),
    );
  }
}

class _DiagnosisDoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const _DiagnosisDoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3EBF3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              doctor.imageUrl,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF7F96AE)),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      '${doctor.rating.toStringAsFixed(1)} ★',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF39C12),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Text(
                        doctor.name,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1C2B39),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF5E7288),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(
                    '${doctor.price} ريال • ${doctor.location}',
                    '${doctor.price} SAR • ${doctor.location}',
                  ),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF5E7288),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDetailsPage(doctor: doctor),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5C97),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.tr('احجز الآن', 'Book Now'),
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class _MedicalArtwork extends StatelessWidget {
  const _MedicalArtwork();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB6D4EC), width: 2),
            ),
          ),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD3A7C7), width: 1.6),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              22,
              (index) => Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index.isEven
                      ? const Color(0xFFB678B2)
                      : const Color(0xFF7BB5D9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<DoctorEntity> _recommendedDoctors(
  DoctorsState doctorsState,
  DiagnosisState diagnosisState,
) {
  final doctors = doctorsState.doctors;
  if (doctors.isEmpty) {
    return const [];
  }

  if (diagnosisState.specialties.isEmpty) {
    return doctors.take(3).toList();
  }

  final scoredDoctors = doctors.map((doctor) {
    final specialty = doctor.specialty.toLowerCase();
    var score = 0;

    for (final recommended in diagnosisState.specialties) {
      final keywords = _specialtyKeywords(recommended);
      for (final keyword in keywords) {
        if (specialty.contains(keyword)) {
          score += 3;
        }
        if (diagnosisState.diagnosisTitle.toLowerCase().contains(keyword)) {
          score += 1;
        }
      }
    }

    if (score == 0 &&
        (specialty.contains('باطنية') ||
            specialty.contains('أسرة') ||
            specialty.contains('عام'))) {
      score = 1;
    }

    return _DoctorScore(doctor: doctor, score: score);
  }).toList()
    ..sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) {
        return byScore;
      }
      return b.doctor.rating.compareTo(a.doctor.rating);
    });

  return scoredDoctors
      .where((entry) => entry.score > 0)
      .take(4)
      .map((entry) => entry.doctor)
      .toList();
}

List<String> _specialtyKeywords(String specialty) {
  final normalized = specialty.toLowerCase();
  final keywords = <String>{normalized};

  if (normalized.contains('صدر')) {
    keywords.addAll(['صدر', 'تنفس', 'رئة', 'أنف']);
  }
  if (normalized.contains('باطن')) {
    keywords.addAll(['باطنية', 'هضمي', 'أسرة', 'عام']);
  }
  if (normalized.contains('أعصاب')) {
    keywords.addAll(['أعصاب', 'مخ', 'صداع']);
  }
  if (normalized.contains('قلب')) {
    keywords.addAll(['قلب', 'ضغط', 'خفقان']);
  }
  if (normalized.contains('أطفال')) {
    keywords.addAll(['أطفال', 'طفل']);
  }
  if (normalized.contains('جلدية')) {
    keywords.addAll(['جلدية', 'حساسية', 'بشرة']);
  }
  if (normalized.contains('نساء')) {
    keywords.addAll(['نساء', 'ولادة']);
  }
  if (normalized.contains('أسرة')) {
    keywords.addAll(['أسرة', 'عام', 'باطنية']);
  }

  return keywords.toList();
}

class _DoctorScore {
  final DoctorEntity doctor;
  final int score;

  const _DoctorScore({
    required this.doctor,
    required this.score,
  });
}
