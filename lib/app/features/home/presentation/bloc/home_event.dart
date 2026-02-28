part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class AddRemoveFavouriteEvent extends HomeEvent {
  final String contactId;
  final bool isFavourite;

  const AddRemoveFavouriteEvent({
    required this.contactId,
    required this.isFavourite,
  });
}

final class CreateContactEvent extends HomeEvent {
  final Contact contact;

  const CreateContactEvent({required this.contact});
}

final class UpdateContactEvent extends HomeEvent {
  final Contact contact;

  const UpdateContactEvent({required this.contact});
}

final class DeleteContactEvent extends HomeEvent {
  final String contactId;

  const DeleteContactEvent({required this.contactId});
}

final class GetAllContactsEvent extends HomeEvent {
  const GetAllContactsEvent();
}

final class GetFavouriteContactsEvent extends HomeEvent {
  const GetFavouriteContactsEvent();
}
