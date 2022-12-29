import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cuz.dart';
import '../services/firestore_service.dart';

class CuzCard extends ConsumerWidget {
  const CuzCard({Key? key, required this.cuz, required this.userName}) : super(key: key);
  final Cuz cuz;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreServiceProvider);

    return GestureDetector(
      onDoubleTap: () {
        if (!cuz.finished) {
          firestore.cuzGet(cuz, userName, context);
        } else {
          if (cuz.user == userName) {
            firestore.cuzDrop(cuz, userName, context);
          }
        }
      },
      child: Card(
        color: cuz.finished ? Colors.grey[300] : Colors.teal[100],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              cuz.name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              cuz.finished ? '${cuz.user} aldı.' : 'Alınmadı',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
