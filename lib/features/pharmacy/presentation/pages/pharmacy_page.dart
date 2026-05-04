import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  final List<String> cart = [];

  final List<String> medicines = const [
    'باراسيتامول 500mg',
    'أموكسيسيلين',
    'فيتامين C',
    'بروفين 400mg',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الأدوية',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'الأدوية الشائعة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...medicines.map((medicine) {
            final inCart = cart.contains(medicine);
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary.withOpacity(0.12),
                  child: Icon(Icons.medication_outlined,
                      color: colorScheme.primary),
                ),
                title: Text(medicine),
                subtitle: Text(inCart ? 'مضاف إلى الطلب' : 'متاح الآن'),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (inCart) {
                        cart.remove(medicine);
                      } else {
                        cart.add(medicine);
                      }
                    });
                  },
                  child: Text(inCart ? 'إزالة' : 'إضافة'),
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تأكيد الطلب'),
                        content: Text('تم تجهيز ${cart.length} عنصر في طلبك.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('تم'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_checkout),
                  label: Text('إتمام الطلب (${cart.length})'),
                ),
              ),
            ),
    );
  }
}
