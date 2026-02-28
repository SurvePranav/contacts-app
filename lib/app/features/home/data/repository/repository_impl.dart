import 'package:contacts_app/app/core/error/exceptions.dart';
import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/core/network/connection_checker.dart';
import 'package:contacts_app/app/features/home/data/datasource/datasource.dart';
import 'package:contacts_app/app/features/home/data/mapper/contact_mapper.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  HomeRepositoryImpl({
    required this.connectionChecker,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> addRemoveFavourite({
    required String contactId,
    required bool isFavourite,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      await remoteDataSource.toggleFavouriteStatus(contactId, isFavourite);
      return right(true);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Contact>> createContact({
    required Contact contact,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      await remoteDataSource.addContact(ContactMapper.toModel(contact));
      return right(contact);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteContact({
    required String contactId,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      await remoteDataSource.deleteContact(contactId);
      return right("Contact deleted successfully");
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Contact>>> getAllContacts() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      final contacts = await remoteDataSource.getAllContacts();
      return right(
        contacts.map((contact) => ContactMapper.toEntity(contact)).toList(),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Contact>>> getFavouriteContacts() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      final contacts = await remoteDataSource.getFavouriteContats();
      return right(
        contacts.map((contact) => ContactMapper.toEntity(contact)).toList(),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Contact>> updateContact({
    required Contact contact,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      await remoteDataSource.updateContact(ContactMapper.toModel(contact));
      return right(contact);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
