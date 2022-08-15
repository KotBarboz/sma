import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/log_in_screen.dart';

class PostScreen extends StatefulWidget {
  static const String id = "posts screen";

  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final imagePicker = ImagePicker();
              imagePicker
                  .pickImage(source: ImageSource.gallery, imageQuality: 40)
                  .then((xFile) {
                if (xFile != null) {
                  final File file = File(xFile.path);

                  Navigator.of(context)
                      .pushNamed(CreatePostScreen.id, arguments: {
                    "imageFile": file,
                  });
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut().then((_) =>
                  Navigator.of(context).pushReplacementNamed(LogInScreen.id));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
