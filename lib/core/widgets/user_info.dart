import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class UserInfo extends StatelessWidget {
  final String greeting;
  final String userName;
  final String? imageUrl;
  final Color? textColor;

  const UserInfo({
    super.key,
    required this.greeting,
    required this.userName,
    required this.imageUrl,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 22,
          backgroundImage: _getImageProvider(imageUrl),
          backgroundColor: colorScheme.surface,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: GoogleFonts.cairo(
                color:
                    textColor?.withOpacity(0.7) ?? colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            Text(
              userName,
              style: GoogleFonts.cairo(
                color: textColor ?? colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ImageProvider _getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const NetworkImage('https://i.pravatar.cc/150?img=11');
    }
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return FileImage(File(imageUrl));
    }
  }
}
