import 'package:application_one/core/Theme/theme.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:application_one/feature/auth/presentation/views/login_page.dart';
import 'package:application_one/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => servicelocator<AuthBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application One',
      theme: theme,
      home: const LoginPage(),
    );
  }
}
