import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/models/fb_response.dart';

class FbAuthController {
  ///Functions:
  ///1) signInWithEmailAndPassword
  ///2) createEmailWithEmailAndPassword
  ///3) signOut
  ///4) forgetPassword
  ///5) currentUser

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FbResponse> create(String email, String password, String name) async{
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.sendEmailVerification();
      await _auth.signOut();
      return FbResponse('Account created successfully, activate email', true);
    } on FirebaseAuthException catch (e){
      return FbResponse(e.message ?? '', false);
    }catch (e){
      return FbResponse('Something went wrong', false);
    }
  }

  Future<FbResponse> signIn(String email, String password) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.emailVerified) {
        return FbResponse('Logged in Successfully', true);
      }else{
        _auth.signOut();
        return FbResponse('Login failed, activate your email', false);
      }
    } on FirebaseAuthException catch (e){
      return FbResponse(e.message ?? '', false);
    }catch(e){
      return FbResponse('Something went wrong', false);
    }
  }

  User get currentUser => _auth.currentUser!;

  Future<void> signOut() async{
    await _auth.signOut();
  }

  Future<void> forgetPassword(String email)async{
     _auth.sendPasswordResetEmail(email: email);
  }

  bool get loggedIn => _auth.currentUser != null;
}