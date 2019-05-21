import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    DocumentReference refRooms = _db.collection('rooms').document(chatId);
    var user = await _auth.currentUser();
    refRooms.updateData({
      'members': FieldValue.arrayUnion([user.uid])
    });
  }

  void updatePosition(String lat, String lon) async {
    var user = await _auth.currentUser();
    DocumentReference refUsers = _db.collection('users').document(user.uid);

    refUsers.updateData({
      'lat': lat,
      'lon': lon
    });
  }

  Stream<DocumentSnapshot> getChatInfo(String roomId) {
    return Firestore.instance
        .collection("rooms")
        .document(roomId)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMessages(String roomId) {
    return Firestore.instance
        .collection("messages")
        .where("roomId", isEqualTo: roomId)
        .orderBy("sent", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMembers(String roomId) {
    return _db.collection('users')
        .where("rooms", arrayContains: roomId)
        .snapshots();
  }

  void addMessage(String roomId, String message) async {
    print('i am here');
    DocumentReference ref = _db.collection('messages').document();
    var user = await _auth.currentUser();
    DocumentReference refUsers = _db.collection('users').document(user.uid);

    await addChatMember(roomId);

    refUsers.updateData({
      'rooms': FieldValue.arrayUnion([roomId])
    });

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

  Future<SaveChatResult> saveChat(String name, List<String> tags) async {
    DocumentReference ref = _db.collection('rooms').document();
    var user = await _auth.currentUser();


    ref.setData({
      //'id': chat.id,
      'creator': user.uid,
      'name': name,
      'tags': tags,
      'members': [user.uid]
    }, merge: true);

    return SaveChatResult(ref.documentID, user.email);
  }
}

class SaveChatResult{
  String chatId, userEmail;
  SaveChatResult(String chatId, userEmail){
    this.chatId = chatId;
    this.userEmail = userEmail;
  }
}

final Repository repository = Repository();
