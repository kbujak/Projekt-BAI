import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_app/model/Chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  readUIDLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_uid';
    return prefs.getInt(key);
  }

  saveUIDLocally(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_uid';
    prefs.setString(key, uid);
  }

  void addChatMember(String chatId) async {
    DocumentReference ref = _db.collection('rooms').document(chatId);
    var user = await _auth.currentUser();
    ref.updateData({
      'members': FieldValue.arrayUnion([user.uid])
    });
  }

  void getChatMembers(List<String> members){
    return _db.collection("users")
  }

  Stream<QuerySnapshot> getChatMessages(String roomId) {
    return Firestore.instance
        .collection("messages")
        .where("roomId", isEqualTo: roomId)
        //.orderBy("sent", descending: true)
        .snapshots();
  }

  void addMessage(String roomId, String message) async {
    print('i am here');
    DocumentReference ref = _db.collection('messages').document();
    //var creator = await readUIDLocally();
    var user = await _auth.currentUser();

    return ref.setData({
      //'id': chat.id,
      'roomId': roomId,
      'sender': user.email,
      'senderId': user.uid,
      'sent': DateTime.now(),
      'message': message,
      'photoUrl': user.photoUrl
    }, merge: true);
  }

  void saveChat(String name, List<String> tags) async {
    DocumentReference ref = _db.collection('rooms').document();
    //var creator = await readUIDLocally();
    var user = await _auth.currentUser();

    return ref.setData({
      //'id': chat.id,
      'creator': user.uid,
      'name': name,
      'tags': tags,
      'members': [user.uid]
    }, merge: true);
  }
}

final Repository repository = Repository();
