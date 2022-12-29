import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihvan_kardesler/views/hatim_card.dart';
import '../components/circular_progress_page.dart';
import '../components/error_page.dart';
import '../providers/firestore_providers.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class HatimPage extends ConsumerWidget {
  const HatimPage({super.key});
  static const routeName = '/HatimPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);
    final firestore = ref.watch(firestoreServiceProvider);
    final kullanici = ref.watch(kullaniciProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Hatimler - ${kullanici.value!.group}'),
        actions: [
          PopupMenuButton<int>(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                enabled: kullanici.value!.isAdmin ? true : false,
                child: const Text("Hatim Ekle"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Çıkış Yap"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              firestore.hatimCreate(group: kullanici.value!.group, context: context);
            } else if (value == 1) {
              auth.signoutUser();
            }
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ref.watch(getHatimlerStreamProvider(kullanici.value!.group)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => HatimCard(
                    hatim: data[index],
                    kullanici: kullanici.value!,
                  ),
                );
              },
              error: (e, trace) => ErrorPage(e, trace),
              loading: () => const CircularProgressPage(),
            ),
      ),
    );
  }
}
