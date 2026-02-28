import 'package:contacts_app/app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:contacts_app/app/core/common/screens/splash_screen.dart';
import 'package:contacts_app/app/core/theme/theme.dart';
import 'package:contacts_app/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:contacts_app/app/features/auth/presentation/pages/login_page.dart';
import 'package:contacts_app/app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Contacts',
      theme: AppTheme.darkThemeMode,
      home: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            return const HomePage();
          } else if (state is AppUserLoading) {
            return const SplashScreen();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
