part of 'reports_page.dart';

final class _ReportsPageError extends StatelessWidget {
  const _ReportsPageError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.appTheme.danger,
        ),
      ),
    );
  }
}
