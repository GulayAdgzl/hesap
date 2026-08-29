import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/sub_feature/product/widgets/product_sheet_widgets.dart';

final class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key, required this.onSubmit});

  final void Function({
    required String name,
    required String unit,
    required double price,
    required int quantity,
    required double criticalThreshold,
    required int maxStock,
  }) onSubmit;

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

final class _AddProductSheetState extends State<AddProductSheet> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _maxStockCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedUnit = 'kg';
  double _criticalThreshold = 15;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _maxStockCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      name: _nameCtrl.text.trim(),
      unit: _selectedUnit,
      price: double.tryParse(_priceCtrl.text) ?? 0,
      quantity: int.tryParse(_maxStockCtrl.text) ?? 0,
      criticalThreshold: _criticalThreshold,
      maxStock: int.tryParse(_maxStockCtrl.text) ?? 500,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.md,
          AppSizes.lg,
          AppSizes.xxl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetHandle(),
              const SizedBox(height: AppSizes.base),
              Row(
                children: [
                  Text(AppStrings.addProduct,
                      style: context.textTheme.titleMedium),
                  const Spacer(),
                  const SheetCloseButton(),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              Text(AppStrings.productName,
                  style: context.textTheme.labelMedium
                      ?.copyWith(color: context.appTheme.muted)),
              const SizedBox(height: 7),
              TextFormField(
                controller: _nameCtrl,
                decoration:
                    sheetInputDecoration(context, AppStrings.productNameHint),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? AppStrings.productNameRequired
                    : null,
              ),
              const SizedBox(height: AppSizes.md + 2),
              Text(AppStrings.unit,
                  style: context.textTheme.labelMedium
                      ?.copyWith(color: context.appTheme.muted)),
              const SizedBox(height: 7),
              UnitChipSelector(
                selected: _selectedUnit,
                onSelect: (u) => setState(() => _selectedUnit = u),
              ),
              const SizedBox(height: AppSizes.md + 2),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.unitCost,
                            style: context.textTheme.labelMedium
                                ?.copyWith(color: context.appTheme.muted)),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: sheetInputDecoration(
                              context, AppStrings.unitCostHint),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.maxStock,
                            style: context.textTheme.labelMedium
                                ?.copyWith(color: context.appTheme.muted)),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: _maxStockCtrl,
                          keyboardType: TextInputType.number,
                          decoration: sheetInputDecoration(
                              context, AppStrings.maxStockHint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md + 2),
              CriticalThresholdSlider(
                value: _criticalThreshold,
                onChanged: (v) => setState(() => _criticalThreshold = v),
              ),
              const SizedBox(height: AppSizes.lg + 2),
              SheetPrimaryButton(
                label: AppStrings.saveProduct,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
