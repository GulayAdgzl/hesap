import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';

import 'package:hesap/core/constants/app_decorations.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

class SettingsAvatar extends StatelessWidget {
  const SettingsAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(AppStrings.appName);

    return Center(
      child: Container(
        width: 88,
        height: 88,
        decoration: AppDecorations.settingsAvatarContainer,
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontWeight: FontWeight.w800,
              fontSize: 28,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}
