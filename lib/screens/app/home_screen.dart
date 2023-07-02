import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app/firebase/fb_auth_controller.dart';
import 'package:firebase_app/firebase/fb_firestore_controller.dart';
import 'package:firebase_app/models/expense.dart';
import 'package:firebase_app/screens/app/expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: (){
              FbAuthController().signOut();
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context)=> const ExpenseScreen(),
                ),
              );
            },
            icon: const Icon(Icons.money_outlined),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/upload_image_screen');
            },
            icon: Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/images_screen');
            },
            icon: Icon(Icons.image_outlined),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Expense>>(
        stream: FbFirestoreController().read(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.monetization_on_outlined),
                    title: Text(snapshot.data!.docs[index].data().title),
                    subtitle: Text(snapshot.data!.docs[index].data().value.toString()),
                    onTap: (){
                      QueryDocumentSnapshot<Expense> documentSnapshot = snapshot.data!.docs[index];
                      Expense expense = documentSnapshot.data();
                      expense.id = documentSnapshot.id;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExpenseScreen(expense: expense),
                          ),
                      );
                    },
                  );
                });
          }else{
            return Center(
              child: Text(
                'No Expenses',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          }
        }
      ),
    );
  }
}
