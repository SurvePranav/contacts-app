import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/core/usecase/usecase.dart';
import 'package:contacts_app/app/features/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddRemoveFavouriteUc implements UseCase<bool, Params> {
  final HomeRepository homeRepository;

  AddRemoveFavouriteUc({required this.homeRepository});

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await homeRepository.addRemoveFavourite(
      contactId: params.contactId,
      isFavourite: params.isFavourite,
    );
  }
}

class Params {
  final String contactId;
  final bool isFavourite;

  Params({required this.contactId, required this.isFavourite});
}
