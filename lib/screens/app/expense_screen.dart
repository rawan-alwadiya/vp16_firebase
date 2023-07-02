import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app/firebase/fb_firestore_controller.dart';
import 'package:firebase_app/models/expense.dart';
import 'package:firebase_app/models/fb_response.dart';
import 'package:firebase_app/utils/context_extension.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key, this.expense}) : super(key: key);

  final Expense? expense;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  late TextEditingController _titleTextEditingController;
  late TextEditingController _valueTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    _titleTextEditingController = TextEditingController(text: widget.expense?.title);
    _valueTextEditingController = TextEditingController(text: widget.expense?.value.toString());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextEditingController.dispose();
    _valueTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
      ),
      body:Column(
        children: [
          TextField(
            controller: _titleTextEditingController,
            keyboardType: TextInputType.text,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              hintText: 'Title',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: _valueTextEditingController,
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              hintText: 'Value',
              prefixIcon: const Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () => _performSave(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _performSave(){
    if(_checkData()){
      _save();
    }
  }

  bool _checkData(){
    if(_titleTextEditingController.text.isNotEmpty &&
        _valueTextEditingController.text.isNotEmpty){
      return true;
    }
    context.showSnackBar(message: 'Enter required data!',error: true);
    return false;
  }

  void _save() async{
    FbResponse response = isNewExpense
        ? await FbFirestoreController().create(expense)
        : await FbFirestoreController().update(expense);

    if(response.success){
      isNewExpense ? clear() : Navigator.pop(context);
    }
    context.showSnackBar(message: response.message, error: !response.success);
  }

  Expense get expense {
   Expense expense = isNewExpense ? Expense() : widget.expense!;
   expense.title = _titleTextEditingController.text;
   expense.value = double.parse(_valueTextEditingController.text);
   return expense;
  }

  void clear(){
    _titleTextEditingController.clear();
    _valueTextEditingController.clear();
  }

  bool get isNewExpense => widget.expense == null;
}
