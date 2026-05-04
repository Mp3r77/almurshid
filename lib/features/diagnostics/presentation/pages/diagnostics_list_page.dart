import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../domain/entities/diagnostic_entities.dart';
import '../bloc/diagnostics_bloc.dart';
import '../bloc/diagnostics_event.dart';
import '../bloc/diagnostics_state.dart';
import '../widgets/diagnostic_center_card.dart';
import 'diagnostic_center_profile_page.dart';
import 'diagnostic_booking_page.dart';

class DiagnosticsListPage extends StatefulWidget {
  const DiagnosticsListPage({super.key});

  @override
  State<DiagnosticsListPage> createState() => _DiagnosticsListPageState();
}

class _DiagnosticsListPageState extends State<DiagnosticsListPage> {
  String searchQuery = '';
  DiagnosticType? selectedType;

  @override
  void initState() {
    super.initState();
    context.read<DiagnosticsBloc>().add(const LoadDiagnosticsCenters());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AppLayout(
      header: AppHeader(
        center: Text(
          l10n.onboardingTitle2,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      searchBar: AppSearchBar(
        hintText: l10n.search,
        showFilter: true,
        onFilterPressed: () => _showFilterSheet(context),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
      body: BlocBuilder<DiagnosticsBloc, DiagnosticsState>(
        builder: (context, state) {
          if (state.status == DiagnosticsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final centers = state.filteredCenters.where((center) {
            final matchesQuery = center.name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                center.services.any((s) =>
                    s.name.toLowerCase().contains(searchQuery.toLowerCase()));
            return matchesQuery;
          }).toList();

          if (centers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noResultsFound,
                    style:
                        GoogleFonts.cairo(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: centers.length,
            itemBuilder: (context, index) {
              final center = centers[index];
              return DiagnosticCenterCard(
                center: center,
                onTap: () {
                  context
                      .read<DiagnosticsBloc>()
                      .add(SelectDiagnosticCenter(center));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DiagnosticCenterProfilePage(center: center),
                    ),
                  );
                },
                onBookTap: () {
                  context
                      .read<DiagnosticsBloc>()
                      .add(SelectDiagnosticCenter(center));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiagnosticBookingPage(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.filterByType,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.all_inclusive),
                  title: Text(l10n.all),
                  trailing: selectedType == null
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() => selectedType = null);
                    context
                        .read<DiagnosticsBloc>()
                        .add(const LoadDiagnosticsCenters());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.biotech_outlined),
                  title: Text(l10n.labs),
                  trailing: selectedType == DiagnosticType.lab
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() => selectedType = DiagnosticType.lab);
                    context.read<DiagnosticsBloc>().add(
                        const LoadDiagnosticsCenters(type: DiagnosticType.lab));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_remote_outlined),
                  title: Text(l10n.radiology),
                  trailing: selectedType == DiagnosticType.radiology
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() => selectedType = DiagnosticType.radiology);
                    context.read<DiagnosticsBloc>().add(
                        const LoadDiagnosticsCenters(
                            type: DiagnosticType.radiology));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
