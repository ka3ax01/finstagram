import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;

  FirebaseService();

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String userId = userCredential.user!.uid;
      print("UserId: $userId");
      final String fileName =
          Timestamp.now().millisecondsSinceEpoch.toString() +
              p.extension(image.path);
      print("FileName: $fileName");
      final UploadTask task =
          _storage.ref('images/$userId/$fileName').putFile(image);
      await task.then((snapshot) async {
        String downloadURL = await snapshot.ref.getDownloadURL();
        print("DownloadURL: $downloadURL");
        await _db.collection(USER_COLLECTION).doc(userId).set({
          "name": name,
          "email": email,
          "image": downloadURL,
        });
      });
      print("Firebase sent files");
      return true;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        currentUser = await getUserData(uid: userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    final DocumentSnapshot doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    return doc.data() as Map;
  }

  Future<bool> postImage(File image) async {
    try {
      final String userId = _auth.currentUser!.uid;
      final String fileName =
          Timestamp.now().millisecondsSinceEpoch.toString() +
              p.extension(image.path);
      final UploadTask task =
          _storage.ref('images/$userId/$fileName').putFile(image);
      return await task.then((snapshot) async {
        final String downloadURL = await snapshot.ref.getDownloadURL();
        await _db.collection(POSTS_COLLECTION).add({
          "userId": userId,
          "timestamp": Timestamp.now(),
          "image": downloadURL,
        });
        return true;
      });
    } catch (e) {
      print("Post Image Error: $e");
      return false;
    }
  }

  Stream<QuerySnapshot> getPostsForUser() {
    final String userID = _auth.currentUser!.uid;
    return _db
        .collection(POSTS_COLLECTION)
        .where('userId', isEqualTo: userID)
        .snapshots();
  }

  Stream<QuerySnapshot> getLatestPosts() {
    return _db
        .collection(POSTS_COLLECTION)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
