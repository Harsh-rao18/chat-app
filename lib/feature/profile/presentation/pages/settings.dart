import 'package:application_one/core/utils/confirm_dialog';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart'; 
import 'package:application_one/feature/auth/presentation/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialog(
                    title: "Logout",
                    text: "Are you sure you want to log out?",
                    callback: () {
                      // Dispatch sign-out event
                      context.read<AuthBloc>().add(AuthSignOut());

                      // Close the dialog
                      Navigator.of(context).pop();

                      // Navigate to login page and remove all previous screens
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  );
                },
              );
            },
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            trailing: const Icon(Icons.arrow_forward),
          )
        ],
      ),
    );
  }
}
