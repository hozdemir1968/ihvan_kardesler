import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/circular_progress_page.dart';
import '../components/error_page.dart';
import '../providers/auth_providers.dart';
import 'login_page.dart';
import 'check_group_page.dart';

class CheckAuthPage extends ConsumerWidget {
  const CheckAuthPage({super.key});
  static const routeName = '/CheckAuthPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (data) {
        return data != null ? const CheckGroupPage() : const LoginPage();
      },
      error: (e, trace) => ErrorPage(e, trace),
      loading: () => const CircularProgressPage(),
    );
  }
}
