import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/circular_progress_page.dart';
import '../components/error_page.dart';
import '../providers/firestore_providers.dart';
import 'cuz_card.dart';

class CuzPage extends ConsumerWidget {
  const CuzPage({Key? key, required this.hatimId, required this.userName}) : super(key: key);
  final String hatimId;
  final String userName;
  static const routeName = '/CuzPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cüzler'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ref.watch(getCuzlerStreamProvider(hatimId)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => CuzCard(cuz: data[index], userName: userName),
                );
              },
              error: (e, trace) => ErrorPage(e, trace),
              loading: () => const CircularProgressPage(),
            ),
      ),
    );
  }
}
