import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/model/LocationInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Repository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<LocationInfo> fetchLocationInfo(String lat, String lon) async {
    var apiKey = "key=863dd0ce9edc43e3a3696954b3182b67";
    var latLonParams = "&q=" + lat + "+" + lon;
    var otherParams = "&pretty=1&no_annotations=1";
    var baseUrl = "https://api.opencagedata.com/geocode/v1/json?";

    var url = baseUrl + apiKey + latLonParams + otherParams;

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return LocationInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

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

  void updateLocationInfo(String locationInfo) async{
    var user = await _auth.currentUser();
    DocumentReference refUsers = _db.collection('users').document(user.uid);

    refUsers.updateData({
      'locationInfo': locationInfo
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

  Stream<QuerySnapshot> getCurrentUser(String uid){
    return _db.collection('users')
        .where("uid", isEqualTo: uid)
       .snapshots();
  }

  Stream<QuerySnapshot> getPeopleAroundYou() {
    return _db.collection('users')
        .limit(10)
        .orderBy('lon', descending: true)
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
  
  Stream<QuerySnapshot> getChatsByParticipatory(String userId) {
    return _db.collection("rooms")
        .where("members", arrayContains: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatsByCreator(String userId) {
    return _db.collection("rooms")
        .where("creator", isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatsByTag(String tag) {
    return _db.collection("rooms")
        .where("tags", arrayContains: tag)
        .snapshots();
  }

  void addMessage(String roomId, String message) async {
    print('i am here');
    DocumentReference ref = _db.collection('messages').document();
    var user = await _auth.currentUser();
    DocumentReference refUsers = _db.collection('users').document(user.uid);

    var url = user.photoUrl == null ? "https://image.freepik.com/free-vector/man-avatar-profile-round-icon_24640-14044.jpg" : user.photoUrl;
    var email = user.email == null ? "anonymous" : user.email;

    await addChatMember(roomId);

    refUsers.updateData({
      'rooms': FieldValue.arrayUnion([roomId])
    });

    return ref.setData({
      //'id': chat.id,
      'roomId': roomId,
      'sender': email,
      'senderId': user.uid,
      'sent': DateTime.now(),
      'message': message,
      'photoUrl': url
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
