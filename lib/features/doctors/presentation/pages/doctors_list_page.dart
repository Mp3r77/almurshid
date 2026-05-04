import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:untitled1/core/widgets/section_header.dart';
import 'package:untitled1/features/doctors/presentation/bloc/doctors_event.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../bloc/doctors_bloc.dart';
import '../../../../core/utils/user_bloc.dart';
import '../bloc/doctors_state.dart';
import 'dart:io';
import '../widgets/doctor_card.dart';

class DoctorsListPage extends StatefulWidget {
  final String initialQuery;

  const DoctorsListPage({super.key, this.initialQuery = ''});

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<DoctorsBloc>();
      // Always load doctors if not loaded or if there's an error
      if (bloc.state.status == DoctorsStatus.initial ||
          bloc.state.status == DoctorsStatus.failure ||
          bloc.state.doctors.isEmpty) {
        bloc.add(LoadDoctorsEvent());
      }
      // Then handle search if needed
      if (widget.initialQuery.trim().isNotEmpty) {
        bloc.add(SearchDoctorsEvent(widget.initialQuery.trim()));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AppLayout(
      backgroundColor: Colors.grey[100],
      header: AppHeader(
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => Navigator.pop(context),
        ),
        center: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcome,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.user.fullName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            );
          },
        ),
        leading: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return CircleAvatar(
              radius: 24,
              backgroundImage: _getImageProvider(state.user.imageUrl),
              backgroundColor: Colors.white,
            );
          },
        ),
      ),
      searchBar: AppSearchBar(
        hintText: l10n.search,
        controller: _searchController,
        showFilter: true,
        onFilterPressed: () {},
        onChanged: (value) {
          context.read<DoctorsBloc>().add(SearchQueryChangedEvent(value));
        },
      ),
      body: BlocBuilder<DoctorsBloc, DoctorsState>(
        builder: (context, state) {
          if (state.status == DoctorsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // التعامل مع حالة الفشل
          if (state.status == DoctorsStatus.failure) {
            return ErrorStateView(
              message: state.errorMessage ?? l10n.errorOccurred,
              onRetry: () =>
                  context.read<DoctorsBloc>().add(LoadDoctorsEvent()),
            );
          }

          if (state.isEmpty) {
            return Center(
              child: Text(
                state.searchQuery.isNotEmpty
                    ? 'لا يوجد تطابق مع البحث: "${state.searchQuery}"'
                    : 'لا يوجد أطباء متاحين حالياً',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            itemCount: state.displayDoctors.length,
            itemBuilder: (context, index) {
              return DoctorCard(
                doctor: state.displayDoctors[index],
              );
            },
          );
        },
      ),
    );
  }

  ImageProvider _getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const NetworkImage('https://i.pravatar.cc/150?img=47');
    }
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
}
