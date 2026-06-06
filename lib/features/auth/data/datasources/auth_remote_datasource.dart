import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> _profileDataFromUser(
    User user, {
    String? name,
    int? age,
    String? gender,
    double? weight,
    double? height,
    String? activityLevel,
    List<String>? healthConditions,
    bool includeLoginMetadata = false,
  }) {
    final now = FieldValue.serverTimestamp();
    return <String, dynamic>{
      'uid': user.uid,
      '_id': user.uid,
      'name': name ?? user.displayName ?? '',
      'email': user.email ?? '',
      'emailVerified': user.emailVerified,
      'age': age ?? 0,
      'gender': gender ?? 'male',
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel ?? 'moderate',
      'healthConditions': healthConditions ?? <String>[],
      if (includeLoginMetadata) 'lastLoginAt': now,
      'updatedAt': now,
    };
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await user.getIdToken();
    if (token != null) {
      await prefs.setString('auth_token', token);
    }
  }

  Future<UserModel> _loadProfile(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return UserModel.fromJson({
        '_id': user.uid,
        'name': data['name'] ?? user.displayName ?? '',
        'email': data['email'] ?? user.email ?? '',
        'age': data['age'] ?? 0,
        'gender': data['gender'] ?? 'male',
        'weight': data['weight'],
        'height': data['height'],
        'activityLevel': data['activityLevel'] ?? 'moderate',
        'healthConditions': data['healthConditions'] ?? const <String>[],
      });
    }

    final fallbackProfile = _profileDataFromUser(user);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(fallbackProfile, SetOptions(merge: true));

    return UserModel.fromJson(fallbackProfile);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Login failed. Please try again.');
    }

    await _saveSession(user);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
          _profileDataFromUser(user, includeLoginMetadata: true),
          SetOptions(merge: true),
        );

    final profile = await _loadProfile(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'current_user',
      json.encode({
        '_id': profile.id,
        'name': profile.name,
        'email': profile.email,
        'age': profile.age,
        'gender': profile.gender,
        'weight': profile.weight,
        'height': profile.height,
        'activityLevel': profile.activityLevel,
        'healthConditions': profile.healthConditions,
      }),
    );

    return profile;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Registration failed. Please try again.');
    }

    await user.updateDisplayName(name);

    final userData = _profileDataFromUser(
      user,
      name: name,
      age: age,
      gender: gender,
      includeLoginMetadata: true,
    )..addAll({'createdAt': FieldValue.serverTimestamp()});

    await _firestore.collection('users').doc(user.uid).set(userData);
    await user.reload();
    await _saveSession(user);

    final profile = UserModel.fromJson(userData);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'current_user',
      json.encode({
        '_id': profile.id,
        'name': profile.name,
        'email': profile.email,
        'age': profile.age,
        'gender': profile.gender,
        'weight': profile.weight,
        'height': profile.height,
        'activityLevel': profile.activityLevel,
        'healthConditions': profile.healthConditions,
      }),
    );

    return profile;
  }

  Future<UserModel> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user found');
    }

    return _loadProfile(user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('current_user');
    await _auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return _auth.currentUser != null || prefs.containsKey('auth_token');
  }
}
