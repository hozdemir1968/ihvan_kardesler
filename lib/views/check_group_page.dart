import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/circular_progress_page.dart';
import '../components/error_page.dart';
import '../providers/firestore_providers.dart';
import 'group_choose.dart';
import 'hatim_page.dart';

class CheckGroupPage extends ConsumerWidget {
  const CheckGroupPage({super.key});
  static const routeName = '/CheckGroupPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kullanici = ref.watch(kullaniciProvider);

    return kullanici.when(
      data: (data) {
        if (data != null) {
          return data.group != '' ? const HatimPage() : const GroupChoosePage();
        }
        return const GroupChoosePage();
      },
      error: (e, trace) => ErrorPage(e, trace),
      loading: () => const CircularProgressPage(),
    );
  }
}
