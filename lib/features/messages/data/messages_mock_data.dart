class ChatMessage {
  final String id;
  final String text;
  final DateTime time;
  final bool isSentByMe;
  final bool isRead;
  final String? type; // "text", "audio", "video", "image"
  final String? localAudioPath;

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isSentByMe,
    this.isRead = true,
    this.type = "text",
    this.localAudioPath,
  });
}

class ChatThread {
  final String id;
  final String participantName;
  final String participantType; // "Doctor" or "Lab"
  final String profileImageUrl;
  final String lastMessage;
  final String lastMessageTimeStr;
  final int unreadCount;
  final bool isOnline;
  final List<ChatMessage> messages;

  ChatThread({
    required this.id,
    required this.participantName,
    required this.participantType,
    required this.profileImageUrl,
    required this.lastMessage,
    required this.lastMessageTimeStr,
    required this.unreadCount,
    required this.isOnline,
    required this.messages,
  });
}

final List<ChatThread> mockChatThreads = [
  ChatThread(
      id: "1",
      participantName: "د. أحمد علي",
      participantType: "Doctor",
      profileImageUrl: "https://i.pravatar.cc/150?img=11",
      lastMessage: "تم تأكيد موعد الاستشارة الطبية الخاص بك",
      lastMessageTimeStr: "10:30 ص",
      unreadCount: 1,
      isOnline: true,
      messages: [
        ChatMessage(
            id: "m1",
            text: "مرحباً دكتور أحمد",
            time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
            isSentByMe: true),
        ChatMessage(
            id: "m2",
            text: "أهلاً بك، كيف يمكنني مساعدتك؟",
            time: DateTime.now().subtract(const Duration(days: 1)),
            isSentByMe: false),
        ChatMessage(
            id: "m3",
            text:
                "أود الاستفسار عن إمكانية حجز موعد للاستشارة حول نتائج التحاليل الأخيرة.",
            time: DateTime.now().subtract(const Duration(minutes: 60)),
            isSentByMe: true),
        ChatMessage(
            id: "m4",
            text: "تم تأكيد موعد الاستشارة الطبية الخاص بك",
            time: DateTime.now().subtract(const Duration(minutes: 5)),
            isSentByMe: false,
            isRead: false),
      ]),
  ChatThread(
      id: "2",
      participantName: "مختبر البرج",
      participantType: "Lab",
      profileImageUrl: "https://i.pravatar.cc/150?img=9",
      lastMessage: "نتائج التحاليل أصبحت جاهزة، يمكنك ا...",
      lastMessageTimeStr: "أمس",
      unreadCount: 0,
      isOnline: false,
      messages: []),
  ChatThread(
      id: "3",
      participantName: "د. سارة خالد",
      participantType: "Doctor",
      profileImageUrl: "https://i.pravatar.cc/150?img=5",
      lastMessage: "هل تشعر بأي تحسن بعد تناول الدواء؟",
      lastMessageTimeStr: "9:15 ص",
      unreadCount: 3,
      isOnline: true,
      messages: [
        ChatMessage(
            id: "m1",
            text: "السلام عليكم دكتورة سارة",
            time: DateTime.now().subtract(const Duration(days: 2)),
            isSentByMe: true),
        ChatMessage(
            id: "m2",
            text: "وعليكم السلام، تفضل",
            time: DateTime.now().subtract(const Duration(days: 2)),
            isSentByMe: false),
        ChatMessage(
            id: "m3",
            text: "هل أستمر على نفس الجرعة؟",
            time: DateTime.now().subtract(const Duration(hours: 4)),
            isSentByMe: true),
        ChatMessage(
            id: "m4",
            text: "نعم استمر عليها لمدة أسبوع إضافي",
            time: DateTime.now().subtract(const Duration(hours: 3)),
            isSentByMe: false,
            isRead: false),
        ChatMessage(
            id: "m5",
            text: "كيف حالك اليوم؟",
            time: DateTime.now().subtract(const Duration(hours: 2)),
            isSentByMe: false,
            isRead: false),
        ChatMessage(
            id: "m6",
            text: "هل تشعر بأي تحسن بعد تناول الدواء؟",
            time: DateTime.now().subtract(const Duration(minutes: 10)),
            isSentByMe: false,
            isRead: false),
      ]),
  ChatThread(
      id: "4",
      participantName: "د. محمد إبراهيم",
      participantType: "Doctor",
      profileImageUrl: "https://i.pravatar.cc/150?img=12",
      lastMessage: "سأقوم بمراجعة التقارير والرد عليك قريباً",
      lastMessageTimeStr: "الجمعة",
      unreadCount: 0,
      isOnline: false,
      messages: []),
  ChatThread(
      id: "5",
      participantName: "مختبر ثقة",
      participantType: "Lab",
      profileImageUrl: "https://i.pravatar.cc/150?img=60",
      lastMessage: "أرسل صورة: تقرير الفحص المخبري رقم...",
      lastMessageTimeStr: "الأسبوع الماضي",
      unreadCount: 0,
      isOnline: false,
      messages: []),
];
