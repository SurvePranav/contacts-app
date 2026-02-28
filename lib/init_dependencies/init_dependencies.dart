import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:contacts_app/app/core/network/connection_checker.dart';
import 'package:contacts_app/app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:contacts_app/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:contacts_app/app/features/auth/domain/repository/auth_repository.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/current_user.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/user_login.dart';
import 'package:contacts_app/app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:contacts_app/app/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'init_dependency_logic.dart';
