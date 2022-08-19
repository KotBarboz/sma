import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/widgets/message_list_tile.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String _message = "";

  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    print(currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(post.postId)
                    .collection("comments")
                    .orderBy("timestamp")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      final QueryDocumentSnapshot doc =
                          snapshot.data!.docs[index];

                      print(doc.data());

                      final ChatModel chatModel = ChatModel(
                          userName: doc.data().toString().contains('userName')
                              ? doc.get('userName')
                              : '',
                          userId: doc.data().toString().contains('userId')
                              ? doc.get('userId')
                              : '',
                          message: doc.data().toString().contains('message')
                              ? doc.get('message')
                              : '',
                          timestamp: doc.data().toString().contains('timestamp')
                              ? doc.get('timestamp')
                              : '');

                      return Align(
                          alignment: chatModel.userId == currentUserId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: MessageListTile(chatModel));
                    },
                  );
                },
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Enter message",
                        ),
                        onChanged: (value) {
                          _message = value;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(post.postId)
                          .collection("comments")
                          .add({
                            "userId": FirebaseAuth.instance.currentUser!.uid,
                            "userName":
                                FirebaseAuth.instance.currentUser!.displayName,
                            "message": _message,
                            "timestamp": Timestamp.now(),
                          })
                          .then((value) => {debugPrint("chat doc added")})
                          .catchError((error) => {
                                debugPrint(
                                    "Error has occurred while adding chat doc")
                              });

                      _textEditingController.clear();

                      setState() {
                        _message = "";
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
