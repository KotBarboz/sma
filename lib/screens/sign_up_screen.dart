import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/log_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign-up screen";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _username = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;
  late final FocusNode _usernameFocusNode;

  @override
  initState() {
    _passwordFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();

    super.initState();
  }

  @override
  dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();

    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    context
        .read<AuthCubit>()
        .signUp(email: _email, userName: _username, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (prevState, currentState) {
            if (currentState is AuthSignedUp) {
              // Navigator.of(context).pushReplacementNamed(PostScreen.id);
            }
            if (currentState is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(currentState.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          "Social Media App",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Enter your email"),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_usernameFocusNode);
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter email";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        focusNode: _usernameFocusNode,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Enter your username"),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        onSaved: (value) {
                          _username = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter username";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Enter your password"),
                        obscureText: true,
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password";
                          }
                          if (value.length < 5) {
                            return "Please enter longer password";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _submit(context);
                                },
                                child: const Text("Sign Up")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(LogInScreen.id);
                                },
                                child: const Text("Sign In")),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
