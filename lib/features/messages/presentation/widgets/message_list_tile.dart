import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/messages_mock_data.dart';
import '../pages/chat_screen.dart';

class MessageListTile extends StatelessWidget {
  final ChatThread thread;

  const MessageListTile({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(thread: thread),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar with online status
            Stack(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: thread.unreadCount > 0
                          ? colorScheme.primary.withOpacity(0.3)
                          : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(thread.profileImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (thread.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            // Name and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.participantName,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: thread.unreadCount > 0
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (thread.messages.isNotEmpty &&
                          thread.messages.last.isSentByMe)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.done_all,
                            size: 14,
                            color: thread.messages.last.isRead
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          thread.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: thread.unreadCount > 0
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                            fontWeight: thread.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Time and Notification Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  thread.lastMessageTimeStr,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: thread.unreadCount > 0
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: thread.unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (thread.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${thread.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 24), // Placeholder for alignment
              ],
            ),
          ],
        ),
      ),
    );
  }
}
