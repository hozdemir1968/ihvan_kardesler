import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cuz.dart';
import '../models/grup.dart';
import '../models/hatim.dart';
import '../models/kullanici.dart';
import '../services/firestore_service.dart';

final kullaniciProvider = FutureProvider.autoDispose<Kullanici?>((ref) {
  final provider = ref.read(firestoreServiceProvider);
  return provider.getCurrentKullanici();
});

final grupStreamProvider = StreamProvider.autoDispose<List<Grup>>((ref) {
  final provider = ref.watch(firestoreServiceProvider);
  return provider.getGruplar();
});

final getHatimlerStreamProvider =
    StreamProvider.autoDispose.family<List<Hatim>, String>((ref, groupName) {
  final provider = ref.watch(firestoreServiceProvider);
  return provider.streamHatimler(groupName);
});

final getCuzlerStreamProvider =
    StreamProvider.autoDispose.family<List<Cuz>, String>((ref, hatimId) {
  final provider = ref.watch(firestoreServiceProvider);
  return provider.streamCuzler(hatimId);
});
