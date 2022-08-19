import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/chat_screen.dart';
import 'package:social_media_app/screens/create_post_screen.dart';

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
              // context.read<AuthCubit>().signOut().then((_) =>
              //     Navigator.of(context).pushReplacementNamed(LogInScreen.id));
              context.read<AuthCubit>().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error!!!"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text("Error!!!"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

              final Post post = Post(
                  postId: doc.data().toString().contains('postId')
                      ? doc.get('postId')
                      : '',
                  userName: doc.data().toString().contains('userName')
                      ? doc.get('userName')
                      : '',
                  timestamp: doc.data().toString().contains('timestamp')
                      ? doc.get('timestamp')
                      : '',
                  description: doc.data().toString().contains('description')
                      ? doc.get('description')
                      : '',
                  imageUrl: doc.data().toString().contains('imageUrl')
                      ? doc.get('imageUrl')
                      : '',
                  userId: doc.data().toString().contains('userId"')
                      ? doc.get('userId"')
                      : '');

              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ChatScreen.id, arguments: post);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(post.imageUrl),
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        post.userName,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        post.description,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
