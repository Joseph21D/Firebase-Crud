import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async {
  List people = [];
  CollectionReference collectionReferencePeople = db.collection('people');

  QuerySnapshot queryPeople = await collectionReferencePeople.get();

  for (var doc in queryPeople.docs) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    Map person = {
      "name": data["name"],
      "surname": data["surname"],
      "uid": doc.id,
    };
    people.add(person);
  }

  return people;
}

Future<void> addPeople(String name, String surname) async {
  await db.collection("people").add({
    'name': name,
    'surname': surname  
  });
}

Future<void> updatePeople(String uid, String name, String surname) async {
  await db.collection("people").doc(uid).set({
    'name': name,
    'surname': surname,
  });
}

Future<void> deletePeople(String uid) async {
  await db.collection("people").doc(uid).delete();
}