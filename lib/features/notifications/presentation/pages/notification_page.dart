import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/bloc/home_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationView(tabController: _tabController);
  }
}

class NotificationView extends StatelessWidget {
  final TabController tabController;

  const NotificationView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'مركز الإشعارات',
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: colorScheme.onSurface),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.read<HomeBloc>().add(const ChangeBottomNavIndex(0));
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorColor: colorScheme.primary,
                indicatorWeight: 3,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('الكل'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '12',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Tab(text: 'غير مقروءة'),
                  const Tab(text: 'تنبيهات هامة'),
                  const Tab(text: 'المواعيد'),
                ],
              ),
              const Divider(height: 1, thickness: 1),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildNotificationsList(context),
          _buildEmptyState(context, 'لا توجد إشعارات غير مقروءة'),
          _buildEmptyState(context, 'لا توجد تنبيهات هامة'),
          _buildEmptyState(context, 'لا توجد مواعيد قادمة'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.cairo(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.status == NotificationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.today.isEmpty &&
            state.yesterday.isEmpty &&
            state.older.isEmpty) {
          return _buildEmptyState(context, 'لا توجد إشعارات');
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          children: [
            if (state.today.isNotEmpty) ...[
              const _SectionHeader(title: 'اليوم'),
              ...state.today.map((n) => NotificationCard(notification: n)),
            ],
            if (state.yesterday.isNotEmpty) ...[
              const SizedBox(height: 10),
              const _SectionHeader(title: 'أمس'),
              ...state.yesterday.map((n) => NotificationCard(notification: n)),
            ],
            if (state.older.isNotEmpty) ...[
              const SizedBox(height: 10),
              const _SectionHeader(title: 'أقدم'),
              ...state.older.map((n) => NotificationCard(notification: n)),
            ],
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
