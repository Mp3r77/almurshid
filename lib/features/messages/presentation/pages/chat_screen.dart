import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../data/messages_mock_data.dart';
import '../bloc/messages_bloc.dart';
import '../bloc/messages_event.dart';
import '../bloc/messages_state.dart';
import '../widgets/audio_player_bubble.dart';
import 'video_call_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatThread thread;

  const ChatScreen({super.key, required this.thread});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Audio Recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    if (_msgController.text.trim().isEmpty) return;

    context.read<MessagesBloc>().add(
          SendMessage(
            threadId: widget.thread.id,
            text: _msgController.text.trim(),
          ),
        );

    _msgController.clear();
    setState(() {});

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        final Directory tempDir = await getTemporaryDirectory();
        final String path =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      debugPrint("Error starting record: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null && File(path).existsSync()) {
        if (!mounted) return;
        context.read<MessagesBloc>().add(
              SendAudioMessage(
                threadId: widget.thread.id,
                audioPath: path,
                duration: "0:00", // Would parse duration properly in a real app
              ),
            );
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Error stopping record: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MessagesBloc, MessagesState>(
      builder: (context, state) {
        final currentThread = state.threads.firstWhere(
          (t) => t.id == widget.thread.id,
          orElse: () => widget.thread,
        );

        final reversedMessages =
            List<ChatMessage>.from(currentThread.messages.reversed);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65),
            child: AppBar(
              backgroundColor: colorScheme.surface,
              elevation: 1,
              shadowColor: Colors.black12,
              leadingWidth: 40,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: colorScheme.onSurface, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(currentThread.profileImageUrl),
                      ),
                      if (currentThread.isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentThread.participantName,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          currentThread.isOnline ? 'متصل الآن' : 'غير متصل',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: currentThread.isOnline
                                ? Colors.green
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon:
                      Icon(Icons.videocam_outlined, color: colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallScreen(
                          participantName: currentThread.participantName,
                          profileImageUrl: currentThread.profileImageUrl,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call_outlined, color: colorScheme.primary),
                  onPressed: () {
                    // Start Video Call but with Camera off initially
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallScreen(
                          participantName: currentThread.participantName,
                          profileImageUrl: currentThread.profileImageUrl,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    itemCount: reversedMessages.length,
                    itemBuilder: (context, index) {
                      final msg = reversedMessages[index];
                      return _buildChatBubble(msg, colorScheme);
                    },
                  ),
                ),
              ),
              _buildInputArea(context, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(ChatMessage msg, ColorScheme colorScheme) {
    final format = DateFormat('hh:mm a');

    return Align(
      alignment: msg.isSentByMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isSentByMe ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isSentByMe ? 16 : 0),
            bottomRight: Radius.circular(msg.isSentByMe ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (msg.type == 'audio' && msg.localAudioPath != null)
              AudioPlayerBubble(
                audioPath: msg.localAudioPath!,
                isSentByMe: msg.isSentByMe,
                colorScheme: colorScheme,
              )
            else
              Text(
                msg.text,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  color: msg.isSentByMe
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  format.format(msg.time),
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    color: msg.isSentByMe
                        ? colorScheme.onPrimary.withOpacity(0.7)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (msg.isSentByMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: msg.isRead ? Colors.lightBlueAccent : Colors.white70,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ColorScheme colorScheme) {
    bool hasText = _msgController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle_outline,
                  color: colorScheme.primary, size: 28),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                constraints:
                    const BoxConstraints(minHeight: 45, maxHeight: 120),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _isRecording
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.mic, color: Colors.red),
                                  const SizedBox(width: 10),
                                  Text(
                                    "جاري التسجيل...",
                                    style: GoogleFonts.cairo(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : TextField(
                              controller: _msgController,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              onChanged: (val) => setState(() {}),
                              style: GoogleFonts.cairo(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: 'اكتب رسالة...',
                                hintStyle: GoogleFonts.cairo(
                                    color: colorScheme.onSurfaceVariant),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                            ),
                    ),
                    if (!_isRecording && !hasText)
                      IconButton(
                        icon: Icon(Icons.camera_alt_outlined,
                            color: colorScheme.onSurfaceVariant),
                        onPressed: () {},
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onLongPress: hasText ? null : () => _startRecording(),
              onLongPressUp: hasText ? null : () => _stopRecording(),
              onTap: hasText ? () => _sendMessage(context) : () {},
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    hasText ? Icons.send : Icons.mic,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
