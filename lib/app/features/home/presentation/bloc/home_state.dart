// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {
  final List<Contact> contacts;
  final BlocStatus allContactsStatus;
  final List<Contact> favouriteContacts;
  final BlocStatus favouriteContactsStatus;
  final String? errorMessage;
  final BlocStatus toggleFavouriteStatus;
  final BlocStatus createUpdateContactStatus;
  final BlocStatus deleteContactStatus;

  HomeState({
    this.contacts = const [],
    this.allContactsStatus = BlocStatus.initial,
    this.favouriteContacts = const [],
    this.favouriteContactsStatus = BlocStatus.initial,
    this.errorMessage,
    this.toggleFavouriteStatus = BlocStatus.initial,
    this.createUpdateContactStatus = BlocStatus.initial,
    this.deleteContactStatus = BlocStatus.initial,
  });

  HomeState copyWith({
    List<Contact>? contacts,
    BlocStatus? allContactsStatus,
    List<Contact>? favouriteContacts,
    BlocStatus? favouriteContactsStatus,
    String? errorMessage,
    BlocStatus? toggleFavouriteStatus,
    BlocStatus? createUpdateContactStatus,
    BlocStatus? deleteContactStatus,
  }) {
    return HomeState(
      contacts: contacts ?? this.contacts,
      allContactsStatus: allContactsStatus ?? this.allContactsStatus,
      favouriteContacts: favouriteContacts ?? this.favouriteContacts,
      favouriteContactsStatus:
          favouriteContactsStatus ?? this.favouriteContactsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      toggleFavouriteStatus:
          toggleFavouriteStatus ?? this.toggleFavouriteStatus,
      createUpdateContactStatus:
          createUpdateContactStatus ?? this.createUpdateContactStatus,
      deleteContactStatus: deleteContactStatus ?? this.deleteContactStatus,
    );
  }
}
