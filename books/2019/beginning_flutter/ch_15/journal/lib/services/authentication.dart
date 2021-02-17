import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth() => _firebaseAuth;

  // Responsible for retrieving the currently logged-in user.uid
  Future<String> currentUserUid() async {
    User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  // Responsible for logging out the current user
  Future<void> signOut() => _firebaseAuth.signOut();

  // Responsible for logging in a user by email/password authentication
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user.uid;
  }

  // Responsible for creating a user by email/password authentication
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user.uid;
  }

  // Responsible for retrieving the current logged-in user. Once the user is retrieved,
  // it sends an email to the user to verify it was them creating the account
  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    return user.sendEmailVerification();
  }

  // Responsible for retrieving the current logged-in user. Once the user is retrieved,
  // verify the user has verified their email
  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}
