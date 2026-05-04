import 'package:equatable/equatable.dart';

import '../../data/messages_mock_data.dart';

enum MessagesStatus { initial, loading, success, failure }

class MessagesState extends Equatable {
  final MessagesStatus status;
  final List<ChatThread> threads;
  final String? errorMessage;
  final String searchQuery;

  const MessagesState({
    this.status = MessagesStatus.initial,
    this.threads = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  MessagesState copyWith({
    MessagesStatus? status,
    List<ChatThread>? threads,
    String? errorMessage,
    String? searchQuery,
  }) {
    return MessagesState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, threads, errorMessage, searchQuery];
}
