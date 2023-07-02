import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/models/expense.dart';
import 'package:firebase_app/models/fb_response.dart';
import 'package:firebase_app/utils/firebase_helper.dart';

class FbFirestoreController with FirebaseHelper{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Operations
///1) create
///2) Read
///3) Update
///4) Delete
  
  Future<FbResponse> create(Expense expense) async{
    return _firestore
        .collection('Expenses')
        .add(expense.toMap())
        .then((value) => getResponse())
        .catchError((error) => getResponse(error: true));
  }

  Stream<QuerySnapshot<Expense>> read() async*{
    yield* _firestore
        .collection('Expenses')
        .withConverter<Expense>(
          fromFirestore: (snapshot, options) => Expense.fromMap(snapshot.data()!),
        toFirestore: (value, options) => value.toMap())
        .snapshots();
  }

  Future<FbResponse> update(Expense expense) async{
   return _firestore
       .collection('Expenses')
       .doc(expense.id)
       .update(expense.toMap())
       .then((value) => getResponse())
       .catchError((error)=> getResponse(error: true));
  }

  Future<FbResponse> delete(String id) async{
    return _firestore
        .collection('Expenses')
        .doc(id)
        .delete()
        .then((value) => getResponse())
        .catchError((error)=> getResponse(error: true));
  }
}