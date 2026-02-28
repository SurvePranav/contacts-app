import 'dart:async';
import 'dart:developer';

import 'package:contacts_app/app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:contacts_app/app/core/usecase/usecase.dart';
import 'package:contacts_app/app/core/entities/user.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/current_user.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/user_login.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/user_logout.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserLogout _userLogout;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserLogout userLogout,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       _userLogout = userLogout,

       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_authIsUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final response = await _userSignUp(
      UserSignupParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final response = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    response.fold(
      (l) => emit(AuthFailureState(message: l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  FutureOr<void> _authIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    log("checking what is wrong");
    _appUserCubit.updateUser(null, isChecking: true);
    final res = await _currentUser(NoParams());

    res.fold((l) {
      _appUserCubit.updateUser(null);
      emit(AuthLoggedOutState());
    }, (r) => _emitAuthSuccess(r, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccessState(user: user));
  }

  FutureOr<void> _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final res = await _userLogout(NoParams());

    res.fold((l) => emit(LogoutFailureState(message: l.message)), (r) {
      _appUserCubit.updateUser(null);
      emit(AuthLoggedOutState());
    });
  }
}
