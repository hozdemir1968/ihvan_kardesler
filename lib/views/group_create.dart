import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihvan_kardesler/services/firestore_service.dart';
import '../components/error_page.dart';
import '../components/circular_progress_page.dart';
import '../providers/common_providers.dart';
import '../providers/firestore_providers.dart';
import 'group_choose.dart';

class GroupCreatePage extends ConsumerStatefulWidget {
  const GroupCreatePage({super.key});
  static const routeName = '/GroupCreatPage';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends ConsumerState<GroupCreatePage> {
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreServiceProvider);
    final kullanici = ref.watch(kullaniciProvider);
    final groups = ref.watch(grupStreamProvider);
    final name = ref.watch(groupNameControllerProvider);
    final secretWord = ref.watch(groupSecretWordControllerProvider);

    void checkAndCreateGroup() {
      if (name != '' && secretWord != '') {
        kullanici.when(
            data: (data) async {
              if (data != null) {
                firestore.groupCreate(
                  groupName: name,
                  secretWord: secretWord,
                  kullanici: data,
                  context: context,
                );
                Phoenix.rebirth(context);
              }
            },
            error: (e, trace) => ErrorPage(e, trace),
            loading: () => const CircularProgressPage());
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Grup oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: groups.when(
          data: (data) {
            return Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Bir grup oluşturun',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    ref.read(groupNameControllerProvider.notifier).state = value;
                  },
                  decoration: const InputDecoration(hintText: 'Grup adı...'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    ref.read(groupSecretWordControllerProvider.notifier).state = value;
                  },
                  decoration: const InputDecoration(hintText: 'Gizli kelime...'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: checkAndCreateGroup,
                  child: const Text('Oluştur'),
                ),
                Flexible(flex: 1, child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Yeni bir grup mu kurmak istiyorsunuz ? '),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, GroupChoosePage.routeName);
                        },
                        child: const Text('Değiştir !')),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          },
          error: (e, trace) => ErrorPage(e, trace),
          loading: () => const CircularProgressPage(),
        ),
      ),
    );
  }
}
