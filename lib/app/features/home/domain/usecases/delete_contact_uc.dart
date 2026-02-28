import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/core/usecase/usecase.dart';
import 'package:contacts_app/app/features/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteContactUc implements UseCase<String, String> {
  final HomeRepository homeRepository;

  DeleteContactUc({required this.homeRepository});

  @override
  Future<Either<Failure, String>> call(String contactId) async {
    return await homeRepository.deleteContact(contactId: contactId);
  }
}
