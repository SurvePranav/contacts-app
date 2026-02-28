import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, bool>> addRemoveFavourite({
    required String contactId,
    required bool isFavourite,
  });

  Future<Either<Failure, Contact>> createContact({required Contact contact});

  Future<Either<Failure, String>> deleteContact({required String contactId});

  Future<Either<Failure, Contact>> updateContact({required Contact contact});

  Future<Either<Failure, List<Contact>>> getAllContacts();
  Future<Either<Failure, List<Contact>>> getFavouriteContacts();
}
