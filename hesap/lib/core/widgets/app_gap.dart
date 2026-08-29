import 'package:flutter/widgets.dart';
import 'package:hesap/core/theme/app_design_system.dart';

final class AppGap extends StatelessWidget {
  const AppGap._(this.size, {this.axis = Axis.vertical});

  final double size;
  final Axis axis;

  static const AppGap xxs =
      AppGap._(4); // AppSizes.xs ile aynı, 2-6px ince ayarlar için
  static const AppGap xs = AppGap._(AppSizes.xs);
  static const AppGap sm = AppGap._(AppSizes.sm);
  static const AppGap md = AppGap._(AppSizes.md);
  static const AppGap base = AppGap._(AppSizes.base);
  static const AppGap lg = AppGap._(AppSizes.lg);
  static const AppGap xl = AppGap._(AppSizes.xl);
  static const AppGap xxl = AppGap._(AppSizes.xxl);

  static const AppGap xsHorizontal =
      AppGap._(AppSizes.xs, axis: Axis.horizontal);
  static const AppGap smHorizontal =
      AppGap._(AppSizes.sm, axis: Axis.horizontal);
  static const AppGap baseHorizontal =
      AppGap._(AppSizes.base, axis: Axis.horizontal);

  @override
  Widget build(BuildContext context) {
    return axis == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}
