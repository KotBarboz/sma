import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/log_in_screen.dart';
import 'package:social_media_app/screens/post_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

// Ideal time to initialize
//   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Social Media APP',
        theme: ThemeData.dark(),
        home: const SignUpScreen(),
        routes: {
          LogInScreen.id: (context) => const LogInScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          PostScreen.id: (context) => const PostScreen(),
          CreatePostScreen.id: (context) => const CreatePostScreen(),
        },
      ),
    );
  }
}
