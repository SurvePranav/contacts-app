import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/core/usecase/usecase.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllContactsUc implements UseCase<List<Contact>, NoParams> {
  final HomeRepository homeRepository;

  GetAllContactsUc({required this.homeRepository});

  @override
  Future<Either<Failure, List<Contact>>> call(NoParams params) async {
    return await homeRepository.getAllContacts();
  }
}
