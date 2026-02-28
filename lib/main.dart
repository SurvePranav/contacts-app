import 'package:contacts_app/app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:contacts_app/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:contacts_app/app/my_app.dart';
import 'package:contacts_app/init_dependencies/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
