import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/widgets/product_sheet_widgets.dart';

/// Ürün düzenleme bottom sheet'i.
///
/// Cubit bağımlılığı yoktur; güncellenen [Product] [onSubmit] callback'i
/// ile üst katmana (Mixin → ViewModel) iletilir.
final class EditProductSheet extends StatefulWidget {
  const EditProductSheet({
    super.key,
    required this.product,
    required this.onSubmit,
  });

  final Product product;
  final void Function(Product updated) onSubmit;

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

final class _EditProductSheetState extends State<EditProductSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _maxStockCtrl;
  final _formKey = GlobalKey<FormState>();
  late String _selectedUnit;
  late double _criticalThreshold;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.name);
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _maxStockCtrl =
        TextEditingController(text: widget.product.quantity.toString());
    _selectedUnit = widget.product.unit.isNotEmpty
        ? widget.product.unit
        : AppStrings.units.first;
    _criticalThreshold = widget.product.criticalThreshold;
  }

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
      widget.product.copyWith(
        name: _nameCtrl.text.trim(),
        price: double.tryParse(_priceCtrl.text) ?? widget.product.price,
        quantity: int.tryParse(_maxStockCtrl.text) ?? widget.product.quantity,
        unit: _selectedUnit,
        criticalThreshold: _criticalThreshold,
      ),
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
                  Text(AppStrings.editProduct,
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
                          decoration: sheetInputDecoration(context, '₺0.00'),
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
                          decoration: sheetInputDecoration(context, '500'),
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
                label: AppStrings.saveChanges,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
