import 'package:flutter/material.dart';
import 'package:hesap/core/initializer/application_initializer.dart';
import 'package:hesap/main_app.dart';

void main() async {
  ApplicationInitializer.run();
  await ApplicationInitializer.prepare();
  runApp(const MainApp());
}
