import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/hatim.dart';
import '../models/kullanici.dart';
import '../services/firestore_service.dart';
import 'cuz_page.dart';

class HatimCard extends ConsumerWidget {
  const HatimCard({Key? key, required this.hatim, required this.kullanici}) : super(key: key);
  final Hatim hatim;
  final Kullanici kullanici;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreServiceProvider);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CuzPage.routeName,
            arguments: {"hatimId": hatim.id, "userName": kullanici.name});
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Dikkat'),
            content: const Text('Silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Vazgeç')),
              TextButton(
                  onPressed: () {
                    firestore.hatimDelete(uid: kullanici.uid, hatimId: hatim.id, context: context);
                    Navigator.pop(context);
                  },
                  child: const Text('Sil')),
            ],
          ),
        );
      },
      child: Card(
        color: hatim.finished ? Colors.grey[300] : Colors.teal[100],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              hatim.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('dd-MM-yyy  ').add_Hm().format(hatim.createDate),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            Text(
              hatim.finished ? 'Tamamlandı' : 'Tamamlanmadı',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
