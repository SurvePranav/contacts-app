import 'package:contacts_app/app/core/error/exceptions.dart';
import 'package:contacts_app/app/core/error/failures.dart';
import 'package:contacts_app/app/core/network/connection_checker.dart';
import 'package:contacts_app/app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:contacts_app/app/core/entities/user.dart';
import 'package:contacts_app/app/features/auth/data/models/user_model.dart';
import 'package:contacts_app/app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepoSitoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepoSitoryImpl({
    required this.connectionChecker,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentSession;

        if (session == null) {
          return left(Failure('user not logged in!'));
        }

        return right(
          UserModel(id: session.uid, email: session.email ?? '', name: ''),
        );
      }

      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      final user = await remoteDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet Connection!'));
      }
      await remoteDataSource.logout();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
