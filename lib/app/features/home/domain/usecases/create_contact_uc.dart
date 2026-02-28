import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/core/usecase/usecase.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateContactUc implements UseCase<Contact, Contact> {
  final HomeRepository homeRepository;

  CreateContactUc({required this.homeRepository});

  @override
  Future<Either<Failure, Contact>> call(Contact params) async {
    return await homeRepository.createContact(contact: params);
  }
}
