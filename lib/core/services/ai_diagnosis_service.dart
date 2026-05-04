import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiDiagnosisService {
  static const String _baseUrl =
      'https://router.huggingface.co/v1/chat/completions';
  static const String _defaultModel = 'm42-health/Llama3-Med42-8B';

  static Future<Map<String, dynamic>> getDiagnosis(String symptoms) async {
    try {
      final token = _readToken();
      final model = dotenv.env['HF_MEDICAL_MODEL']?.trim().isNotEmpty == true
          ? dotenv.env['HF_MEDICAL_MODEL']!.trim()
          : _defaultModel;

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'model': model,
              'messages': [
                {
                  'role': 'system',
                  'content': '''
You are a medical triage assistant for preliminary assessment only.
The user may write symptoms in Arabic.
Analyze the symptoms and reply in Arabic only.
Do not claim certainty.
Do not provide dangerous treatment instructions.
Always remind the user that this is not a final diagnosis.
Return valid JSON only in this exact schema:
{
  "title": "اسم الحالة المحتملة أو الأقرب",
  "subtitle": "شرح مختصر مع تنبيه أن النتيجة أولية فقط ومتى يجب مراجعة الطبيب أو الطوارئ",
  "specialties": ["التخصص الطبي الأنسب", "تخصص إضافي عند الحاجة"]
}
If symptoms are unclear, include "طب أسرة" in specialties.
If symptoms suggest urgency, mention urgency clearly in subtitle.
''',
                },
                {
                  'role': 'user',
                  'content': 'حلل هذه الأعراض بشكل تشخيص أولي فقط: $symptoms',
                },
              ],
              'temperature': 0.1,
              'max_tokens': 400,
              'stream': false,
            }),
          )
          .timeout(const Duration(seconds: 45));

      final bodyText = utf8.decode(response.bodyBytes);
      final body = bodyText.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(bodyText) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(
          _extractApiError(body) ??
              'فشل الاتصال بمزود النموذج الطبي. رمز الحالة: ${response.statusCode}.',
        );
      }

      final choices = body['choices'];
      if (choices is! List || choices.isEmpty) {
        throw Exception(
          'استجابة مزود الذكاء الاصطناعي لا تحتوي على نتيجة قابلة للقراءة.',
        );
      }

      final message = choices.first['message'] as Map<String, dynamic>?;
      final content = message?['content'];
      if (content is! String || content.trim().isEmpty) {
        throw Exception('لم يتم استلام محتوى تشخيص من النموذج الطبي.');
      }

      return _parseAiResponse(content);
    } catch (e) {
      return _buildLocalFallbackDiagnosis(
        symptoms,
        reason: e.toString().replaceFirst('Exception: ', '').trim(),
      );
    }
  }

  static String _readToken() {
    final token = dotenv.env['HF_TOKEN']?.trim();
    final fallback = dotenv.env['HUGGING_FACE_TOKEN']?.trim();
    final resolved = (token?.isNotEmpty == true) ? token! : fallback;

    if (resolved == null || resolved.isEmpty) {
      throw Exception(
        'لم يتم العثور على HF_TOKEN. تم استخدام التشخيص المحلي الاحتياطي.',
      );
    }

    return resolved;
  }

  static Map<String, dynamic> _parseAiResponse(String response) {
    final cleaned = _stripMarkdownCodeFence(response.trim());

    try {
      final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
      final title = (decoded['title'] as String?)?.trim();
      final subtitle = (decoded['subtitle'] as String?)?.trim();
      final rawSpecialties = decoded['specialties'];

      final specialties = rawSpecialties is List
          ? rawSpecialties
              .whereType<String>()
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toSet()
              .toList()
          : <String>[];

      return {
        'title': title?.isNotEmpty == true ? title : 'تشخيص أولي غير محدد',
        'subtitle': subtitle?.isNotEmpty == true
            ? subtitle
            : 'هذه النتيجة أولية فقط وليست بديلًا عن استشارة طبيب مختص.',
        'specialties': specialties.isNotEmpty ? specialties : ['طب أسرة'],
      };
    } catch (_) {
      throw Exception(
        'تعذر قراءة رد النموذج الطبي. تحقق من صيغة الاستجابة أو جرّب مرة أخرى.',
      );
    }
  }

  static String _stripMarkdownCodeFence(String value) {
    if (!value.startsWith('```')) {
      return value;
    }

    return value
        .replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '')
        .replaceFirst(RegExp(r'\n?```$'), '')
        .trim();
  }

  static String? _extractApiError(Map<String, dynamic> body) {
    final error = body['error'];
    if (error is Map<String, dynamic>) {
      final message = error['message'];
      if (message is String && message.trim().isNotEmpty) {
        return _mapApiErrorMessage(message.trim());
      }
      final type = error['type'];
      if (type is String && type.trim().isNotEmpty) {
        return _mapApiErrorMessage(type.trim());
      }
    }
    return null;
  }

  static String _mapApiErrorMessage(String message) {
    final normalized = message.toLowerCase();

    if (normalized.contains('authorization') ||
        normalized.contains('unauthorized') ||
        normalized.contains('invalid token')) {
      return 'مفتاح Hugging Face غير صحيح أو لا يملك صلاحية Inference Providers.';
    }

    if (normalized.contains('rate limit')) {
      return 'تم تجاوز الحد المسموح للطلبات مؤقتًا من مزود النموذج.';
    }

    if (normalized.contains('quota') ||
        normalized.contains('payment') ||
        normalized.contains('billing') ||
        normalized.contains('credits')) {
      return 'انتهت الحصة المجانية أو توجد مشكلة فوترة في حساب Hugging Face.';
    }

    if (normalized.contains('model') && normalized.contains('not found')) {
      return 'النموذج الطبي المحدد غير متاح حاليًا عبر Hugging Face.';
    }

    if (normalized.contains('provider')) {
      return 'مزود الاستدلال غير متاح حاليًا لهذا النموذج.';
    }

    return message;
  }

  static Map<String, dynamic> _buildLocalFallbackDiagnosis(
    String symptoms, {
    required String reason,
  }) {
    final normalized = symptoms.toLowerCase();
    final specs = <String>{'طب أسرة'};
    var title = 'حالة عامة تحتاج تقييمًا سريريًا';
    var advice =
        'تم استخدام تحليل محلي احتياطي داخل التطبيق لأن خدمة الذكاء الاصطناعي غير متاحة حاليًا.';

    if (_hasAny(normalized, ['سعال', 'كحة', 'ضيق', 'تنفس', 'بلغم', 'صدر'])) {
      title = 'اشتباه التهاب أو تهيج بالجهاز التنفسي';
      specs.addAll(['طب صدري', 'أمراض باطنية']);
      advice =
          'قد ترتبط الأعراض بعدوى تنفسية أو التهاب بالشعب الهوائية. إذا وُجد ضيق نفس شديد أو زرقة أو ألم صدر حاد فهذه حالة تستدعي الطوارئ.';
    } else if (_hasAny(normalized, ['صداع', 'دوخة', 'صداع نصفي', 'زغللة'])) {
      title = 'اشتباه صداع توتري أو صداع نصفي';
      specs.addAll(['مخ وأعصاب', 'أمراض باطنية']);
      advice =
          'قد يكون السبب صداعًا توتريًا أو نصفيًا أو مرتبطًا بالإجهاد والجفاف. إذا كان الصداع مفاجئًا وشديدًا جدًا أو صاحبه ضعف أو اضطراب كلام فاذهب للطوارئ.';
    } else if (_hasAny(
        normalized, ['بطن', 'معدة', 'غثيان', 'استفراغ', 'إسهال'])) {
      title = 'اشتباه اضطراب بالجهاز الهضمي';
      specs.addAll(['جهاز هضمي', 'أمراض باطنية']);
      advice =
          'قد ترتبط الأعراض بالتهاب معدة أو قولون أو عدوى هضمية. إذا وُجد جفاف شديد أو دم أو ألم حاد مستمر في البطن فيلزم تقييم عاجل.';
    } else if (_hasAny(normalized, ['جلد', 'حكة', 'طفح', 'حبوب', 'احمرار'])) {
      title = 'اشتباه مشكلة جلدية أو حساسية';
      specs.addAll(['جلدية']);
      advice =
          'قد ترتبط الأعراض بحساسية أو التهاب جلدي. إذا كان الطفح منتشرًا بسرعة أو صاحبه تورم بالوجه أو صعوبة تنفس فاذهب للطوارئ.';
    } else if (_hasAny(normalized, ['قلب', 'خفقان', 'ضغط', 'ألم صدر'])) {
      title = 'اشتباه أعراض قلبية أو دورانية';
      specs.addAll(['أمراض قلبية', 'أمراض باطنية']);
      advice =
          'ألم الصدر أو الخفقان يحتاج تقييمًا طبيًا قريبًا. إذا كان ألم الصدر شديدًا أو ممتدًا للذراع أو الفك أو مع ضيق نفس فهذه طوارئ.';
    } else if (_hasAny(
        normalized, ['حرارة', 'حمى', 'تعب', 'إرهاق', 'التهاب'])) {
      title = 'اشتباه عدوى أو التهاب عام';
      specs.addAll(['أمراض باطنية']);
      advice =
          'قد تكون الأعراض مرتبطة بعدوى فيروسية أو بكتيرية أو التهاب عام. استمرار الحمى أو تدهور الحالة يستدعي مراجعة الطبيب.';
    }

    return {
      'title': title,
      'subtitle':
          '$advice هذه النتيجة أولية فقط وليست تشخيصًا نهائيًا. سبب استخدام الوضع الاحتياطي: $reason',
      'specialties': specs.toList(),
    };
  }

  static bool _hasAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}
