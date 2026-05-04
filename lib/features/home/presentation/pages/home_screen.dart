import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../doctors/presentation/pages/doctors_list_page.dart';
import '../bloc/home_bloc.dart';
import '../widgets/categories_grid.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AppLayout(
      backgroundColor: colorScheme.primary,
      header: const HomeHeader(),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == HomeStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? l10n.errorOccurred),
                );
              }

              if (state.status == HomeStatus.success) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromoBanner(),
                      const SizedBox(height: 20),
                      SectionHeader(
                        title: l10n.mainSections,
                        // actionText: l10n.viewDoctors,
                        onActionPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DoctorsListPage(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      const SizedBox(height: 20),
                      const CategoriesGrid(),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
