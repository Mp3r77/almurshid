import 'package:equatable/equatable.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends MessagesEvent {}

class SearchMessages extends MessagesEvent {
  final String query;

  const SearchMessages(this.query);

  @override
  List<Object?> get props => [query];
}

class SendMessage extends MessagesEvent {
  final String threadId;
  final String text;

  const SendMessage({required this.threadId, required this.text});

  @override
  List<Object?> get props => [threadId, text];
}

class SendAudioMessage extends MessagesEvent {
  final String threadId;
  final String audioPath;
  final String duration;

  const SendAudioMessage({
    required this.threadId,
    required this.audioPath,
    required this.duration,
  });

  @override
  List<Object?> get props => [threadId, audioPath, duration];
}
