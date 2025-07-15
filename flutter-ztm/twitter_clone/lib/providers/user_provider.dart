import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/users.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser{
  final String id;
  final FirebaseUser user;

  const LocalUser({required this.id, required this.user});

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,  
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserNotifier(): super(LocalUser(id: "error", user: FirebaseUser(email: "error", name: "error", profilePicture: "error")));

  Future<void> getUserInfo(String email) async {
    QuerySnapshot response = await _firestore.collection("users").where('email', isEqualTo: email).get();
    if (response.docs.isEmpty) {
      print("No Firestore user associated with email $email");
      return;
    }
    if (response.docs.length != 1) {
      print("More than one Firestore user associated with email $email");
      return;
    }
    state = LocalUser(id: response.docs[0].id, user: FirebaseUser.fromMap(response.docs[0].data() as Map<String, dynamic>));
  }

  Future<void> addUsertoDB(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
      FirebaseUser(
        email: email, 
        name: "No Name", 
        profilePicture: "https://www.gravatar.com/avatar/?d=mp",
      ).toMap(),
    );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(id: response.id, user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  void clearUserState() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(email: "error", name: "error", profilePicture: "error")
    );
  }
}