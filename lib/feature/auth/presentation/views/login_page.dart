import 'package:application_one/core/common/widgets/snackbar.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:application_one/feature/auth/presentation/views/register_page.dart';
import 'package:application_one/feature/auth/presentation/widgets/auth_input.dart';
import 'package:application_one/feature/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final emailfocusNode = FocusNode();
  final passwordfocusNode = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    emailfocusNode.dispose();
    passwordfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    showSnackBar(context, state.message);
                  } else if (state is AuthSuccess) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                        (route) => false);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  }
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 60,
                          width: 60,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Welcome to hi5!!",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AuthInput(
                          hintText: "Enter your email",
                          labelText: "Email",
                          controller: _emailController,
                          focusNode: emailfocusNode,
                          validator: ValidationBuilder()
                              .required()
                              .email()
                              .maxLength(50)
                              .build(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AuthInput(
                          hintText: "Enter your password",
                          labelText: "Password",
                          controller: _passwordController,
                          focusNode: passwordfocusNode,
                          isPassword: !_isPasswordVisible,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                right: BorderSide.strokeAlignCenter),
                            child: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: ValidationBuilder()
                              .required()
                              .minLength(6)
                              .maxLength(12)
                              .build(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                          },
                          child: RichText(
                              text: const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 196, 119, 18),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ])),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
