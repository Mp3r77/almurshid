import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/locale/locale_extensions.dart';
import '../bloc/diagnosis_bloc.dart';
import '../bloc/diagnosis_event.dart';
import '../bloc/diagnosis_state.dart';
import 'smart_diagnosis_results_page.dart';

class SmartDiagnosisScreen extends StatelessWidget {
  const SmartDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiagnosisBloc(),
      child: const _SmartDiagnosisView(),
    );
  }
}

class _SmartDiagnosisView extends StatelessWidget {
  const _SmartDiagnosisView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('التشخيص الذكي', 'Smart Diagnosis'),
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocListener<DiagnosisBloc, DiagnosisState>(
        listenWhen: (previous, current) =>
            previous.status != DiagnosisStatus.success &&
            current.status == DiagnosisStatus.success,
        listener: (context, state) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<DiagnosisBloc>(),
                child: const SmartDiagnosisResultsPage(),
              ),
            ),
          );
        },
        child: BlocBuilder<DiagnosisBloc, DiagnosisState>(
          builder: (context, diagnosisState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _IntroCard(state: diagnosisState),
                  const SizedBox(height: 18),
                  _InputCard(state: diagnosisState),
                  const SizedBox(height: 18),
                  if (diagnosisState.status == DiagnosisStatus.failure &&
                      diagnosisState.error != null) ...[
                    _ErrorCard(message: diagnosisState.error!),
                    const SizedBox(height: 18),
                  ],
                  _AnalyzeButton(status: diagnosisState.status),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final DiagnosisState state;

  const _IntroCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF6FAFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.10),
                  colorScheme.primary.withOpacity(0.18),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.55),
                ),
                child: Icon(
                  Icons.psychology_alt_rounded,
                  size: 42,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            context.tr(
                'كيف يمكنني مساعدتك اليوم؟', 'How can I help you today?'),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.status == DiagnosisStatus.success
                ? context.tr(
                    'تم تجهيز تحليل أولي لحالتك مع ترشيح التخصصات والأطباء الأنسب.',
                    'A preliminary analysis has been prepared with recommended specialties and doctors.',
                  )
                : context.tr(
                    'اكتب الأعراض التي تشعر بها وسنقدم لك تشخيصًا أوليًا مع قائمة بالأطباء المختصين.',
                    'Describe your symptoms and we will provide an initial assessment with recommended doctors.',
                  ),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final DiagnosisState state;

  const _InputCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
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
          Text(
            context.tr('وصف الأعراض', 'Symptoms Description'),
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD9E5F2)),
            ),
            child: TextField(
              maxLines: 6,
              textAlign: TextAlign.right,
              onChanged: (text) {
                context.read<DiagnosisBloc>().add(UpdateTextSymptoms(text));
              },
              decoration: InputDecoration(
                hintText: context.tr(
                  'مثال: أشعر بصداع مستمر منذ يومين مع ارتفاع طفيف في الحرارة وألم في الحلق...',
                  'Example: I have had a persistent headache for two days with mild fever and a sore throat...',
                ),
                hintStyle: GoogleFonts.cairo(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.85),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('اقتراحات شائعة:', 'Common suggestions:'),
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _SymptomChips(selectedSymptoms: state.selectedSymptoms),
        ],
      ),
    );
  }
}


class _SymptomChips extends StatelessWidget {
  final List<String> selectedSymptoms;

  const _SymptomChips({required this.selectedSymptoms});

  static const List<String> symptoms = [
    'headache',
    'fever',
    'cough',
    'shortness_of_breath',
    'back_pain',
    'nausea',
    'migraine',
    'sore_throat',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: symptoms.map((symptom) {
        final isSelected = selectedSymptoms.contains(symptom);

        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            context.read<DiagnosisBloc>().add(ToggleSymptom(symptom));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isSelected ? colorScheme.primary : const Color(0xFFD9E5F2),
              ),
            ),
            child: Text(
              _symptomLabel(context, symptom),
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF4C6177),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  final DiagnosisStatus status;

  const _AnalyzeButton({required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: status == DiagnosisStatus.loading
            ? null
            : () {
                context.read<DiagnosisBloc>().add(const AnalyzeSymptoms());
              },
        icon: status == DiagnosisStatus.loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.auto_awesome_rounded, size: 18),
        label: Text(
          status == DiagnosisStatus.success
              ? context.tr('إعادة التشخيص الذكي', 'Run Smart Diagnosis Again')
              : context.tr('ابدأ التشخيص الذكي', 'Start Smart Diagnosis'),
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A5C97),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD2CF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFC53B2F)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8E2E26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _symptomLabel(BuildContext context, String key) {
  switch (key) {
    case 'headache':
      return context.tr('صداع', 'Headache');
    case 'fever':
      return context.tr('حمى', 'Fever');
    case 'cough':
      return context.tr('سعال', 'Cough');
    case 'shortness_of_breath':
      return context.tr('ضيق تنفس', 'Shortness of breath');
    case 'back_pain':
      return context.tr('ألم ظهر', 'Back pain');
    case 'nausea':
      return context.tr('غثيان', 'Nausea');
    case 'migraine':
      return context.tr('صداع نصفي', 'Migraine');
    case 'sore_throat':
      return context.tr('ألم حلق', 'Sore throat');
    default:
      return key;
  }
}

