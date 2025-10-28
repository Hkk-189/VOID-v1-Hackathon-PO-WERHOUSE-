import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class FirebaseService {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _initialized = true;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
      // Continue in offline mode
    }
  }

  static bool get isInitialized => _initialized;

  static Future<void> registerUser(AppUser user, String hashedPassword) async {
    if (!_initialized) throw Exception('Firebase not initialized');

    try {
      // Create auth user
      final userCredential = await _auth!.createUserWithEmailAndPassword(
        email: '${user.username}@paywave.app',
        password: hashedPassword,
      );

      // Store user data in Firestore
      await _firestore!.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print('Firebase registration error: $e');
      rethrow;
    }
  }

  static Future<AppUser?> loginUser(String username, String password) async {
    if (!_initialized) throw Exception('Firebase not initialized');

    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
        email: '$username@paywave.app',
        password: password,
      );

      // Fetch user data
      final doc = await _firestore!.collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return null;
      return AppUser.fromMap(doc.docs.first.data());
    } catch (e) {
      print('Firebase login error: $e');
      rethrow;
    }
  }

  static Future<void> syncTransaction(PaymentTransaction transaction) async {
    if (!_initialized) throw Exception('Firebase not initialized');

    try {
      await _firestore!.collection('transactions')
          .doc(transaction.id)
          .set(transaction.toMap());
    } catch (e) {
      print('Transaction sync error: $e');
      rethrow;
    }
  }

  static Future<List<PaymentTransaction>> fetchUserTransactions(String userId) async {
    if (!_initialized) throw Exception('Firebase not initialized');

    try {
      final snapshot = await _firestore!.collection('transactions')
          .where('from', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => PaymentTransaction.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Fetch transactions error: $e');
      return [];
    }
  }

  static Future<void> signOut() async {
    if (!_initialized) return;
    await _auth?.signOut();
  }
}
