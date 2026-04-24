import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_decorations.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/features/product/domain/entities/product.dart'
    show Product;

import '../bloc/product_cubit.dart';

class EditProductSheet extends StatefulWidget {
  final Product product;
  const EditProductSheet({super.key, required this.product});

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _maxStockCtrl;
  final _formKey = GlobalKey<FormState>();
  late String _selectedUnit;
  late double _criticalThreshold;
  final _units = AppStrings.units;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.name);
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _maxStockCtrl =
        TextEditingController(text: widget.product.quantity.toString());
    _selectedUnit =
        widget.product.unit.isNotEmpty ? widget.product.unit : _units.first;
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
    context.read<ProductCubit>().updateProduct(
          product: widget.product.copyWith(
            name: _nameCtrl.text.trim(),
            price: double.tryParse(_priceCtrl.text) ?? widget.product.price,
            quantity:
                int.tryParse(_maxStockCtrl.text) ?? widget.product.quantity,
            unit: _selectedUnit,
            criticalThreshold: _criticalThreshold,
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: AppDecorations.sheet,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.handle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Başlık + Kapat
              Row(
                children: [
                  const Text(AppStrings.editProduct,
                      style: AppTextStyles.sheetTitle),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          size: 14, color: AppColors.muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Ürün Adı
              const Text(AppStrings.productName, style: AppTextStyles.label),
              const SizedBox(height: 7),
              TextFormField(
                controller: _nameCtrl,
                decoration:
                    AppDecorations.inputDecoration(AppStrings.productNameHint),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? AppStrings.productNameRequired
                    : null,
              ),
              const SizedBox(height: 14),

              // Birim
              const Text(AppStrings.unit, style: AppTextStyles.label),
              const SizedBox(height: 7),
              Wrap(
                spacing: 8,
                children: _units.map((u) {
                  final sel = u == _selectedUnit;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedUnit = u),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : AppColors.inputFill,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              sel ? AppColors.primary : AppColors.inputBorder,
                        ),
                      ),
                      child: Text(
                        u,
                        style: AppTextStyles.chipText.copyWith(
                          color: sel ? Colors.white : AppColors.muted,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Birim Maliyet + Maks. Stok
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(AppStrings.unitCost,
                            style: AppTextStyles.label),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: AppDecorations.inputDecoration('₺0.00'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(AppStrings.maxStock,
                            style: AppTextStyles.label),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: _maxStockCtrl,
                          keyboardType: TextInputType.number,
                          decoration: AppDecorations.inputDecoration('500'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Kritik Stok Eşiği
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(AppStrings.criticalThreshold,
                      style: AppTextStyles.label),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '%${_criticalThreshold.round()}',
                      style: AppTextStyles.badgeText,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.primaryLight,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withOpacity(0.1),
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 9),
                ),
                child: Slider(
                  value: _criticalThreshold,
                  min: 5,
                  max: 50,
                  divisions: 9,
                  onChanged: (v) => setState(() => _criticalThreshold = v),
                ),
              ),
              const Text(AppStrings.criticalThresholdHint,
                  style: AppTextStyles.caption),
              const SizedBox(height: 18),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(AppStrings.saveChanges,
                      style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
