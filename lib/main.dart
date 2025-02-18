import 'package:application_one/core/Theme/theme.dart';
import 'package:application_one/core/common/cubit/app_user_cubit.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:application_one/feature/auth/presentation/views/login_page.dart';
import 'package:application_one/feature/main_page.dart';
import 'package:application_one/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => servicelocator<AuthBloc>()),
      BlocProvider(create: (_) => servicelocator<AppUserCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application One',
      theme: theme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLogged) {
          if (isLogged) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
