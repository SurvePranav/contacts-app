import 'package:contacts_app/app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:contacts_app/app/core/theme/theme.dart';
import 'package:contacts_app/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:contacts_app/app/features/auth/presentation/pages/login_page.dart';
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
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            // return const HomePage();
            return const Scaffold(body: Center(child: Text("home page")));
          }
          return const LoginPage();
        },
      ),
    );
  }
}
