import 'package:application_one/core/common/widgets/snackbar.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:application_one/feature/auth/presentation/views/login_page.dart';
import 'package:application_one/feature/auth/presentation/widgets/auth_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final namefocusNode = FocusNode();
  final emailfocusNode = FocusNode();
  final passwordfocusNode = FocusNode();
  final confirmPasswordfocusNode = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    namefocusNode.dispose();
    emailfocusNode.dispose();
    passwordfocusNode.dispose();
    confirmPasswordfocusNode.dispose();
    super.dispose();
  }

  void _onsubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthSignUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim()));
    }
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
                            builder: (context) => const LoginPage()),
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
                                "Register",
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
                          hintText: "Enter your name",
                          labelText: "Fullname",
                          controller: _nameController,
                          focusNode: namefocusNode,
                          validator: ValidationBuilder()
                              .required()
                              .minLength(3)
                              .maxLength(50)
                              .build(),
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
                          height: 15,
                        ),
                        AuthInput(
                          hintText: "Confirm your password",
                          labelText: "Confirm password",
                          controller: _confirmPasswordController,
                          focusNode: confirmPasswordfocusNode,
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
                          validator: (args) {
                            if (_passwordController.text != args) {
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _onsubmit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Register",
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
                                    builder: (context) => const LoginPage()));
                          },
                          child: RichText(
                              text: const TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                TextSpan(
                                    text: "Sign In",
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
