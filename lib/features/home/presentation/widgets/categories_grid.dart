import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../diagnostics/presentation/pages/diagnostics_list_page.dart';
import '../../../diagnosis/presentation/pages/smart_diagnosis_screen.dart';
import '../../../doctors/presentation/pages/doctors_list_page.dart';
import '../bloc/home_bloc.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status != HomeStatus.success) {
          return Center(
            child: Text(
              l10n.errorOccurred,
              style: GoogleFonts.cairo(color: colorScheme.onSurfaceVariant),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85,
          ),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final category = state.categories[index];
            final categoryId = category['id'] as String;
            final categoryColor = Color(category['color'] as int);

            return Material(
              color: categoryColor,
              borderRadius: BorderRadius.circular(20),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _openCategory(context, categoryId),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0001),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForCategory(categoryId),
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _getCategoryName(context, categoryId),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.viewAll,
                      style: GoogleFonts.cairo(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openCategory(BuildContext context, String categoryId) {
    if (categoryId == 'pharmacy') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pharmaciesSoon,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orange[800],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final page = switch (categoryId) {
      'doctors' => const DoctorsListPage(),
      'diagnostics' => const DiagnosticsListPage(),
      'diagnosis' => const SmartDiagnosisScreen(),
      _ => const DoctorsListPage(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  String _getCategoryName(BuildContext context, String categoryId) {
    final l10n = AppLocalizations.of(context)!;
    return switch (categoryId) {
      'doctors' => l10n.doctors,
      'diagnostics' => l10n.diagnosticsDesc, // Or something else
      'diagnosis' => l10n.diagnostics,
      'pharmacy' => l10n.pharmacies,
      _ => categoryId,
    };
  }

  IconData _getIconForCategory(String categoryId) {
    return switch (categoryId) {
      'diagnostics' => Icons.biotech_outlined,
      'doctors' => Icons.person_search_outlined,
      'diagnosis' => Icons.psychology_outlined,
      'pharmacy' => Icons.local_pharmacy_outlined,
      _ => Icons.medical_services_outlined,
    };
  }
}
