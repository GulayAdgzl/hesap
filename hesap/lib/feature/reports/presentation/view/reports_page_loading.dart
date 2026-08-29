part of 'reports_page.dart';

final class _ReportsPageLoading extends StatelessWidget {
  const _ReportsPageLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colors.primary),
    );
  }
}
