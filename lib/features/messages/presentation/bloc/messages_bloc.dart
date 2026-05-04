import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/messages_mock_data.dart';
import 'messages_event.dart';
import 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(const MessagesState()) {
    on<LoadMessages>(_onLoadMessages);
    on<SearchMessages>(_onSearchMessages);
    on<SendMessage>(_onSendMessage);
    on<SendAudioMessage>(_onSendAudioMessage);
  }

  void _onLoadMessages(LoadMessages event, Emitter<MessagesState> emit) {
    emit(state.copyWith(status: MessagesStatus.loading));

    // Simulate network delay if you want, but we'll load mock instantly
    emit(state.copyWith(
      status: MessagesStatus.success,
      threads: mockChatThreads,
    ));
  }

  void _onSearchMessages(SearchMessages event, Emitter<MessagesState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSendMessage(SendMessage event, Emitter<MessagesState> emit) {
    final threads = List<ChatThread>.from(state.threads);
    final threadIndex = threads.indexWhere((t) => t.id == event.threadId);

    if (threadIndex != -1) {
      final thread = threads[threadIndex];
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: event.text,
        time: DateTime.now(),
        isSentByMe: true,
      );

      final updatedMessages = List<ChatMessage>.from(thread.messages)
        ..add(newMessage);

      final updatedThread = ChatThread(
        id: thread.id,
        participantName: thread.participantName,
        participantType: thread.participantType,
        profileImageUrl: thread.profileImageUrl,
        lastMessage: event.text,
        lastMessageTimeStr: "الآن",
        unreadCount: thread.unreadCount,
        isOnline: thread.isOnline,
        messages: updatedMessages,
      );

      // Move updated thread to top
      threads.removeAt(threadIndex);
      threads.insert(0, updatedThread);

      emit(state.copyWith(threads: threads));
    }
  }

  void _onSendAudioMessage(
      SendAudioMessage event, Emitter<MessagesState> emit) {
    final threads = List<ChatThread>.from(state.threads);
    final threadIndex = threads.indexWhere((t) => t.id == event.threadId);

    if (threadIndex != -1) {
      final thread = threads[threadIndex];
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'مقطع صوتي (${event.duration})',
        time: DateTime.now(),
        isSentByMe: true,
        type: 'audio',
        localAudioPath: event.audioPath,
      );

      final updatedMessages = List<ChatMessage>.from(thread.messages)
        ..add(newMessage);

      final updatedThread = ChatThread(
        id: thread.id,
        participantName: thread.participantName,
        participantType: thread.participantType,
        profileImageUrl: thread.profileImageUrl,
        lastMessage: '🎤 مقطع صوتي',
        lastMessageTimeStr: "الآن",
        unreadCount: thread.unreadCount,
        isOnline: thread.isOnline,
        messages: updatedMessages,
      );

      // Move updated thread to top
      threads.removeAt(threadIndex);
      threads.insert(0, updatedThread);

      emit(state.copyWith(threads: threads));
    }
  }
}
