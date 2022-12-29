import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../components/utils.dart';
import '../models/cuz.dart';
import '../models/grup.dart';
import '../models/hatim.dart';
import '../models/kullanici.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

class FirestoreService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final int cuzSayisi = 30;

  Future<Kullanici?> getCurrentKullanici() async {
    Kullanici? kullanici;
    var kullaniciData = await firestore.collection('kullanicilar').doc(auth.currentUser?.uid).get();
    if (kullaniciData.data() != null) {
      kullanici = Kullanici.fromMap(kullaniciData.data()!);
    }
    return kullanici;
  }

  Stream<List<Grup>> getGruplar() {
    return firestore
        .collection('gruplar')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Grup.fromMap(doc.data())).toList());
  }

  Future<void> groupCreate({
    required String groupName,
    required String secretWord,
    required Kullanici kullanici,
    required BuildContext context,
  }) async {
    String groupId = groupName;
    try {
      Grup group = Grup(
        id: groupName,
        name: groupName,
        secretWord: secretWord,
        adminName: kullanici.name,
      );
      await firestore.collection('gruplar').doc(groupId).set(group.toMap());
      await firestore.collection('kullanicilar').doc(kullanici.uid).update({
        'group': groupName,
        'isAdmin': true,
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> groupJoin({
    required String groupName,
    required String secretWord,
    required String uid,
    required BuildContext context,
  }) async {
    String grupId = groupName;
    Grup? grup;
    try {
      var grupData = await firestore.collection('gruplar').doc(grupId).get();
      if (grupData.data() != null) {
        grup = Grup.fromMap(grupData.data()!);
      }
      if (grup!.secretWord == secretWord) {
        await firestore.collection('kullanicilar').doc(uid).update({
          'group': groupName,
        });
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<Hatim>> streamHatimler(String groupName) {
    return firestore
        .collection('hatimler')
        .where('group', isEqualTo: groupName)
        .orderBy("createDate", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Hatim.fromJson(doc.data())).toList());
  }

  Future<void> hatimCreate({
    required String group,
    required BuildContext context,
  }) async {
    String hatimId = const Uuid().v1();
    try {
      Hatim hatim = Hatim(
        id: hatimId,
        name: 'Hatim',
        group: group,
        createDate: DateTime.now(),
        finished: false,
      );
      await firestore.collection('hatimler').doc(hatimId).set(hatim.toMap());
      for (int i = 1; i <= cuzSayisi; i++) {
        Cuz cuz = Cuz(
          id: i,
          name: 'Cuz : $i',
          hatimId: hatimId,
          user: "",
          finished: false,
        );
        await firestore
            .collection('hatimler')
            .doc(hatimId)
            .collection('cuzler')
            .doc(i.toString())
            .set(cuz.toMap());
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> hatimDelete({
    required String uid,
    required String hatimId,
    required BuildContext context,
  }) async {
    Kullanici? kullanici;
    try {
      var kullaniciData = await firestore.collection('kullanicilar').doc(uid).get();
      if (kullaniciData.data() != null) {
        kullanici = Kullanici.fromMap(kullaniciData.data()!);
      }
      if (kullanici!.isAdmin) {
        for (int i = 1; i <= cuzSayisi; i++) {
          await firestore
              .collection('hatimler')
              .doc(hatimId)
              .collection('cuzler')
              .doc(i.toString())
              .delete();
        }
        await firestore.collection('hatimler').doc(hatimId).delete();
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Stream<List<Cuz>> streamCuzler(String hatimId) {
    return firestore
        .collection('hatimler')
        .doc(hatimId)
        .collection('cuzler')
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Cuz.fromJson(doc.data())).toList());
  }

  Future<void> cuzGet(Cuz cuz, String userName, BuildContext context) async {
    int sayac = 0;
    Cuz cuzUpdated;
    if (!cuz.finished) {
      cuzUpdated = Cuz(
        id: cuz.id,
        name: cuz.name,
        hatimId: cuz.hatimId,
        user: userName,
        finished: true,
      );
      try {
        await firestore
            .collection('hatimler')
            .doc(cuz.hatimId)
            .collection('cuzler')
            .doc(cuz.id.toString())
            .update(cuzUpdated.toMap());
        CollectionReference cuzCR =
            firestore.collection('hatimler').doc(cuz.hatimId).collection('cuzler');
        QuerySnapshot cuzQS = await cuzCR.get();
        List cuzList = cuzQS.docs.map((e) => e.data()).toList();
        for (int i = 0; i < cuzSayisi; i++) {
          if (cuzList[i]['finished'] == true) {
            sayac++;
          }
        }
        if (sayac == cuzSayisi) {
          await firestore.collection('hatimler').doc(cuz.hatimId).update({'finished': true});
        } else {
          await firestore.collection('hatimler').doc(cuz.hatimId).update({'finished': false});
        }
      } on FirebaseException catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> cuzDrop(Cuz cuz, String userName, BuildContext context) async {
    int sayac = 0;
    Cuz cuzUpdated;
    if (cuz.finished) {
      cuzUpdated = Cuz(
        id: cuz.id,
        name: cuz.name,
        hatimId: cuz.hatimId,
        user: '',
        finished: false,
      );
      try {
        await firestore
            .collection('hatimler')
            .doc(cuz.hatimId)
            .collection('cuzler')
            .doc(cuz.id.toString())
            .update(cuzUpdated.toMap());
        CollectionReference cuzCR =
            firestore.collection('hatimler').doc(cuz.hatimId).collection('cuzler');
        QuerySnapshot cuzQS = await cuzCR.get();
        List cuzList = cuzQS.docs.map((e) => e.data()).toList();
        for (int i = 0; i < cuzSayisi; i++) {
          if (cuzList[i]['finished'] == true) {
            sayac++;
          }
        }
        if (sayac == cuzSayisi) {
          await firestore.collection('hatimler').doc(cuz.hatimId).update({'finished': true});
        } else {
          await firestore.collection('hatimler').doc(cuz.hatimId).update({'finished': false});
        }
      } on FirebaseException catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
