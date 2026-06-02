import 'package:flutter/material.dart';

import 'package:hesap/core/constants/app_text_styles.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(title, style: AppTextStyles.settingsSectionLabel),
    );
  }
}
