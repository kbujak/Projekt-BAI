import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'Repository.dart';

class AuthService {
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  // Shared State for Widgets
  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    updateUserData(user);
    repository.saveUIDLocally(user.uid);

    // Done
    loading.add(false);
    print("signed in " + user.displayName);
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    updateUserData(user);
    repository.saveUIDLocally(user.uid);
    return user;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> signInAnonymously() async{
    FirebaseUser user = await _auth.signInAnonymously();
    updateUserData(user);
    return user;
  }

}

final AuthService authService = AuthService();