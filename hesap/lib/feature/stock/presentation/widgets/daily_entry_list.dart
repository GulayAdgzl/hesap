import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_state.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_card.dart';

class DailyEntryList extends StatelessWidget {
  final TextEditingController Function(String) controllerFor;

  const DailyEntryList({super.key, required this.controllerFor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyEntryCubit, DailyEntryState>(
      builder: (context, state) {
        if (state is DailyEntryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is DailyEntryError) {
          return Center(
            child: Text(state.message,
                style: const TextStyle(color: AppColors.danger)),
          );
        }

        if (state is DailyEntryLoaded) {
          if (state.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 48, color: AppColors.muted),
                  SizedBox(height: 12),
                  Text(AppStrings.noProductsDaily,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.dark)),
                  SizedBox(height: 4),
                  Text(AppStrings.noProductsDailyHint,
                      style: AppTextStyles.caption),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            itemCount: state.products.length,
            itemBuilder: (context, i) {
              final product = state.products[i];
              return DailyEntryCard(
                product: product,
                lastEntry: state.lastEntries[product.id],
                controller: controllerFor(product.id),
                onChanged: (val) => context
                    .read<DailyEntryCubit>()
                    .updateQuantity(product.id, int.tryParse(val)),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
