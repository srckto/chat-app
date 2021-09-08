import 'package:chat_app/widgets/chat/message_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chat").orderBy("createTime", descending: true).snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<QueryDocumentSnapshot<Object?>> docs = snapShot.data!.docs;
          final userId = FirebaseAuth.instance.currentUser;

          return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              return MessageStyle(
                username: docs[index]["userName"],
                message: docs[index]["messageText"],
                imageUser: docs[index]["imageUrl"],
                isMe: userId!.uid == docs[index]["userId"],
                key: ValueKey(docs[index].reference.id),
              );
            },
          );
        }
      },
    );
  }
}
// Text(docs[index]["messageText"].toString()),