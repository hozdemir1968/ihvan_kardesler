import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihvan_kardesler/providers/common_providers.dart';
import '../components/circular_progress_page.dart';
import '../components/error_page.dart';
import '../providers/firestore_providers.dart';
import '../services/firestore_service.dart';
import 'group_create.dart';

class GroupChoosePage extends ConsumerStatefulWidget {
  const GroupChoosePage({super.key});
  static const routeName = '/GroupChoosePage';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupChoosePageState();
}

class _GroupChoosePageState extends ConsumerState<GroupChoosePage> {
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreServiceProvider);
    final kullanici = ref.watch(kullaniciProvider);
    final groups = ref.watch(grupStreamProvider);
    final selectedGroup = ref.watch(dropdownControllerProvider);
    final secretWord = ref.watch(groupSecretWordControllerProvider);

    void checkAndJoinGroup() async {
      if (selectedGroup! != '' && secretWord != '') {
        kullanici.when(
          data: (data) async {
            if (data != null) {
              firestore.groupJoin(
                groupName: selectedGroup,
                secretWord: secretWord,
                uid: data.uid,
                context: context,
              );
              Phoenix.rebirth(context);
            }
          },
          error: (e, trace) => ErrorPage(e, trace),
          loading: () => const CircularProgressPage(),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Grup Seç'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: groups.when(
          data: (data) {
            return Column(
              children: [
                data.isNotEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Bir grup seçin :',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          DropdownButton<String>(
                            iconSize: 30,
                            isExpanded: true,
                            value: selectedGroup,
                            items: data
                                .map((e) => e.name)
                                .toList()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: const Text('Bir grup seçin...'),
                            onChanged: (String? value) {
                              ref.read(dropdownControllerProvider.notifier).state = value!;
                            },
                          ),
                          const SizedBox(height: 25),
                          const Text(
                              'Seçtiğiniz gruba girebilmeniz için grup yöneticisinden aldığınız kelimeyi giriniz'),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              ref.read(groupSecretWordControllerProvider.notifier).state = value;
                            },
                            decoration: const InputDecoration(hintText: 'Gizli kelime?'),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: checkAndJoinGroup,
                              child: const Text('Giriş yap'),
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Henüz Bir Grup yok',
                        style: TextStyle(fontSize: 20),
                      ),
                Flexible(flex: 1, child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Yeni bir grup mu kurmak istiyorsunuz ? '),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, GroupCreatePage.routeName);
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
