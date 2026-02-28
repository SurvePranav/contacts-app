part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initHome();

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      internetConnection: serviceLocator<InternetConnection>(),
    ),
  );
}

void _initAuth() {
  // datasource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );

  // repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepoSitoryImpl(
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
      connectionChecker: serviceLocator<ConnectionChecker>(),
    ),
  );

  // usecases
  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerFactory(
    () => UserLogin(authRepository: serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(authRepository: serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserLogout(authRepository: serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator<UserSignUp>(),
      userLogin: serviceLocator<UserLogin>(),
      currentUser: serviceLocator<CurrentUser>(),
      appUserCubit: serviceLocator<AppUserCubit>(),
      userLogout: serviceLocator<UserLogout>(),
    ),
  );
}

void _initHome() {
  // datasource
  serviceLocator.registerFactory<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );

  // repo
  serviceLocator.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(
      connectionChecker: serviceLocator<ConnectionChecker>(),
      remoteDataSource: serviceLocator<HomeRemoteDataSource>(),
    ),
  );

  // usecases
  serviceLocator.registerFactory(
    () =>
        AddRemoveFavouriteUc(homeRepository: serviceLocator<HomeRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetAllContactsUc(homeRepository: serviceLocator<HomeRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetFavouriteContactsUc(
      homeRepository: serviceLocator<HomeRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateContactUc(homeRepository: serviceLocator<HomeRepository>()),
  );
  serviceLocator.registerFactory(
    () => DeleteContactUc(homeRepository: serviceLocator<HomeRepository>()),
  );
  serviceLocator.registerFactory(
    () => CreateContactUc(homeRepository: serviceLocator<HomeRepository>()),
  );

  // bloc
  serviceLocator.registerLazySingleton(
    () => HomeBloc(
      addRemoveFavouriteUc: serviceLocator<AddRemoveFavouriteUc>(),
      getAllContactsUc: serviceLocator<GetAllContactsUc>(),
      getFavouriteContactsUc: serviceLocator<GetFavouriteContactsUc>(),
      updateContactUc: serviceLocator<UpdateContactUc>(),
      deleteContactUc: serviceLocator<DeleteContactUc>(),
      createContactUc: serviceLocator<CreateContactUc>(),
    ),
  );
}
