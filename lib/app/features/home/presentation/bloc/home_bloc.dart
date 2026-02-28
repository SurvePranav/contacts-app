import 'dart:async';

import 'package:contacts_app/app/core/enums/status.dart';
import 'package:contacts_app/app/core/usecase/usecase.dart';
import 'package:contacts_app/app/features/home/domain/entities/contact_entity.dart';
import 'package:contacts_app/app/features/home/domain/usecases/add_remove_favourite_uc.dart';
import 'package:contacts_app/app/features/home/domain/usecases/create_contact_uc.dart';
import 'package:contacts_app/app/features/home/domain/usecases/delete_contact_uc.dart';
import 'package:contacts_app/app/features/home/domain/usecases/get_all_contacts_uc.dart';
import 'package:contacts_app/app/features/home/domain/usecases/get_favourite_contacts_uc.dart';
import 'package:contacts_app/app/features/home/domain/usecases/update_contact_uc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final AddRemoveFavouriteUc _addRemoveFavouriteUc;
  late final CreateContactUc _createContactUc;
  late final UpdateContactUc _updateContactUc;
  late final DeleteContactUc _deleteContactUc;
  late final GetAllContactsUc _getAllContactsUc;
  late final GetFavouriteContactsUc _getFavouriteContactsUc;

  HomeBloc({
    required AddRemoveFavouriteUc addRemoveFavouriteUc,
    required CreateContactUc createContactUc,
    required UpdateContactUc updateContactUc,
    required DeleteContactUc deleteContactUc,
    required GetAllContactsUc getAllContactsUc,
    required GetFavouriteContactsUc getFavouriteContactsUc,
  }) : _addRemoveFavouriteUc = addRemoveFavouriteUc,
       _createContactUc = createContactUc,
       _updateContactUc = updateContactUc,
       _deleteContactUc = deleteContactUc,
       _getAllContactsUc = getAllContactsUc,
       _getFavouriteContactsUc = getFavouriteContactsUc,

       super(HomeState()) {
    on<AddRemoveFavouriteEvent>(_onAddRemoveFavourite);
    on<CreateContactEvent>(_onCreateContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<GetAllContactsEvent>(_onGetAllContacts);
    on<GetFavouriteContactsEvent>(_onGetFavouriteContacts);
  }

  FutureOr<void> _onAddRemoveFavourite(
    AddRemoveFavouriteEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(favouriteContactsStatus: BlocStatus.loading));

    final result = await _addRemoveFavouriteUc(
      Params(contactId: event.contactId, isFavourite: event.isFavourite),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          favouriteContactsStatus: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(favouriteContactsStatus: BlocStatus.success)),
    );
  }

  FutureOr<void> _onCreateContact(
    CreateContactEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(createUpdateContactStatus: BlocStatus.loading));

    final result = await _createContactUc(event.contact);

    result.fold(
      (failure) => emit(
        state.copyWith(
          createUpdateContactStatus: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(createUpdateContactStatus: BlocStatus.success)),
    );
  }

  FutureOr<void> _onUpdateContact(
    UpdateContactEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(createUpdateContactStatus: BlocStatus.loading));

    final result = await _updateContactUc(event.contact);
    result.fold(
      (failure) => emit(
        state.copyWith(
          createUpdateContactStatus: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(createUpdateContactStatus: BlocStatus.success)),
    );
  }

  FutureOr<void> _onDeleteContact(
    DeleteContactEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(deleteContactStatus: BlocStatus.loading));

    final result = await _deleteContactUc(event.contactId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteContactStatus: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(deleteContactStatus: BlocStatus.success)),
    );
  }

  FutureOr<void> _onGetAllContacts(
    GetAllContactsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(allContactsStatus: BlocStatus.loading));

    final result = await _getAllContactsUc(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          allContactsStatus: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (contacts) => emit(
        state.copyWith(
          contacts: contacts,
          allContactsStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onGetFavouriteContacts(
    GetFavouriteContactsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(favouriteContactsStatus: BlocStatus.loading));

    final result = await _getFavouriteContactsUc(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          favouriteContactsStatus: BlocStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (contacts) => emit(
        state.copyWith(
          favouriteContacts: contacts,
          favouriteContactsStatus: BlocStatus.success,
        ),
      ),
    );
  }
}
