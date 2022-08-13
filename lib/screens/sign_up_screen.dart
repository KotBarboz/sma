import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _username = "";
  String _password = "";

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                    FocusScope.of(context).requestFocus(_usernameFocusNode);
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
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
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
                  onFieldSubmitted: (_) {},
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
                TextButton(onPressed: () {}, child: const Text("Sign Up"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
