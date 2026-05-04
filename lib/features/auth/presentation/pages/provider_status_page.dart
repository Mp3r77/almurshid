import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main_shell.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class ProviderStatusPage extends StatelessWidget {
  const ProviderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isRejected = state.status == AuthStatus.providerRejected;
        final colorScheme = Theme.of(context).colorScheme;

        final title = isRejected
            ? (isArabic ? 'رفض التوثيق' : 'Verification Rejected')
            : (isArabic ? 'مراجعة التوثيق' : 'Verification Review');
        final headline = isRejected
            ? (isArabic
                ? 'لم تتم الموافقة على طلب التوثيق'
                : 'Your verification request was not approved')
            : (isArabic ? 'طلبك قيد المراجعة' : 'Your request is under review');
        final description = isRejected
            ? (isArabic
                ? 'سبب الرفض: الصورة الشخصية غير واضحة أو لا تتطابق مع المستندات.'
                : 'Reason for rejection: the profile image is unclear or does not match the submitted documents.')
            : (isArabic
                ? 'تم استلام طلب إنشاء حسابك بنجاح وهو الآن قيد المراجعة من قبل الإدارة. تستغرق هذه العملية عادة من 24 إلى 48 ساعة.\nستتلقى إشعارًا فور الموافقة على حسابك، وفي هذه الأثناء يمكنك استكشاف التطبيق بميزات محدودة.'
                : 'Your account request has been received and is now under administrative review. This usually takes 24 to 48 hours.\nYou will be notified once your account is approved. In the meantime, you can explore the app with limited access.');
        final buttonLabel = isRejected
            ? (isArabic ? 'إعادة محاولة التوثيق' : 'Retry Verification')
            : (isArabic ? 'حسنًا، فهمت' : 'Okay, got it');
        final supportPrompt = isArabic ? 'تحتاج مساعدة؟ ' : 'Need help? ';
        final supportAction = isArabic ? 'تواصل مع الدعم' : 'Contact support';

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              title,
              style: GoogleFonts.cairo(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward
                    : Icons.arrow_back,
                color: colorScheme.onSurface,
              ),
              onPressed: () {
                if (isRejected) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainShell()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _StatusHeader(isRejected: isRejected),
                const SizedBox(height: 24),
                Text(
                  headline,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isRejected ? colorScheme.error : colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isRejected) {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const MainShell()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isRejected) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        supportPrompt,
                        style: GoogleFonts.cairo(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          supportAction,
                          style: GoogleFonts.cairo(
                            color: colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final bool isRejected;

  const _StatusHeader({required this.isRejected});

  @override
  Widget build(BuildContext context) {
    if (isRejected) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.access_time,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
