import 'package:contacts_app/app/core/error/exceptions.dart';
import 'package:contacts_app/app/features/home/data/models/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<ContactModel>> getAllContacts();
  Future<List<ContactModel>> getFavouriteContats();
  Future<void> addContact(ContactModel contact);
  Future<void> updateContact(ContactModel contact);
  Future<void> deleteContact(String contactId);
  Future<void> toggleFavouriteStatus(String contactId, bool isFavourite);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  /// Helper to get current user UID
  String _getUid() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User not authenticated');
    }
    return user.uid;
  }

  /// Reference to contacts collection
  CollectionReference<Map<String, dynamic>> _contactsRef(String uid) {
    return firestore.collection('users').doc(uid).collection('contacts');
  }

  // ==========================================================
  // ADD CONTACT
  // ==========================================================
  @override
  Future<void> addContact(ContactModel contact) async {
    try {
      final uid = _getUid();

      if (contact.name.trim().isEmpty || contact.phone.trim().isEmpty) {
        throw ServerException('Name and phone number are required');
      }

      // 🔎 Check if phone already exists
      final existing = await _contactsRef(
        uid,
      ).where('phone', isEqualTo: contact.phone).get();

      if (existing.docs.isNotEmpty) {
        throw ServerException('Contact with this phone number already exists');
      }

      final contactId = DateTime.now().millisecondsSinceEpoch.toString();

      final newContact = contact.copyWith(id: contactId);

      await _contactsRef(uid).doc(contactId).set(newContact.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ==========================================================
  // GET ALL CONTACTS
  // ==========================================================
  @override
  Future<List<ContactModel>> getAllContacts() async {
    try {
      final uid = _getUid();

      final snapshot = await _contactsRef(uid).orderBy('name').get();

      return snapshot.docs
          .map((doc) => ContactModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ==========================================================
  // GET FAVOURITES
  // ==========================================================
  @override
  Future<List<ContactModel>> getFavouriteContats() async {
    try {
      final uid = _getUid();

      final snapshot = await _contactsRef(
        uid,
      ).where('isFavourite', isEqualTo: true).get();

      return snapshot.docs
          .map((doc) => ContactModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ==========================================================
  // UPDATE CONTACT
  // ==========================================================
  @override
  Future<void> updateContact(ContactModel contact) async {
    try {
      final uid = _getUid();

      if (contact.name.trim().isEmpty || contact.phone.trim().isEmpty) {
        throw ServerException('Name and phone number are required');
      }

      // 🔎 Check uniqueness except current contact
      final existing = await _contactsRef(
        uid,
      ).where('phone', isEqualTo: contact.phone).get();

      final duplicate = existing.docs.any((doc) => doc.id != contact.id);

      if (duplicate) {
        throw ServerException('Contact with this phone number already exists');
      }

      await _contactsRef(uid).doc(contact.id).update(contact.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ==========================================================
  // DELETE CONTACT
  // ==========================================================
  @override
  Future<void> deleteContact(String contactId) async {
    try {
      final uid = _getUid();

      await _contactsRef(uid).doc(contactId).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ==========================================================
  // TOGGLE FAVOURITE
  // ==========================================================
  @override
  Future<void> toggleFavouriteStatus(String contactId, bool isFavourite) async {
    try {
      final uid = _getUid();

      await _contactsRef(
        uid,
      ).doc(contactId).update({'isFavourite': isFavourite});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
