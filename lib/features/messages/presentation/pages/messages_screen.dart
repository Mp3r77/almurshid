import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/app_search_bar.dart';
import '../../data/messages_mock_data.dart';
import '../bloc/messages_bloc.dart';
import '../bloc/messages_event.dart';
import '../bloc/messages_state.dart';
import '../widgets/message_list_tile.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ChatThread> _getFilteredThreads(
      List<ChatThread> threads, String query, int tabIndex) {
    List<ChatThread> filtered = threads;

    // Filter by Search Query
    if (query.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.participantName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // Filter by Tab
    if (tabIndex == 1) {
      // الأطباء
      filtered = filtered.where((t) => t.participantType == 'Doctor').toList();
    } else if (tabIndex == 2) {
      // المختبرات
      filtered = filtered.where((t) => t.participantType == 'Lab').toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'الرسائل',
          style: GoogleFonts.cairo(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.edit_square, color: colorScheme.onSurface),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: AppSearchBar(
                  backgroundColor: colorScheme.surface,
                  hintText: 'بحث عن طبيب أو مختبر...',
                  onChanged: (val) {
                    context.read<MessagesBloc>().add(SearchMessages(val));
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: colorScheme.primary,
                indicatorWeight: 3,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                onTap: (_) => setState(() {}),
                tabs: const [
                  Tab(text: 'الكل'),
                  Tab(text: 'الأطباء'),
                  Tab(text: 'المختبرات'),
                ],
              ),
              const Divider(height: 1, thickness: 1),
            ],
          ),
        ),
      ),
      body: BlocBuilder<MessagesBloc, MessagesState>(
        builder: (context, state) {
          if (state.status == MessagesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            physics:
                const NeverScrollableScrollPhysics(), // Handle filtering manually to sync with search
            children: [
              _buildMessagesList(context, state, 0),
              _buildMessagesList(context, state, 1),
              _buildMessagesList(context, state, 2),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessagesList(
      BuildContext context, MessagesState state, int tabIndex) {
    final threads =
        _getFilteredThreads(state.threads, state.searchQuery, tabIndex);

    if (threads.isEmpty) {
      return Center(
        child: Text(
          'لا توجد رسائل',
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: threads.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 20, right: 90),
        child: Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      itemBuilder: (context, index) {
        return MessageListTile(thread: threads[index]);
      },
    );
  }
}
