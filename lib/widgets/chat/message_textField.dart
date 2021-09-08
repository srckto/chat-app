import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  MessageTextField({Key? key}) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _messageController = TextEditingController();
  String? message = "";

  _sentMessage() async {
    FocusScope.of(context).unfocus();
    final User? userId = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance.collection("users").doc(userId!.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      "messageText": message,
      "createTime": Timestamp.now(),
      "userName": userData["username"],
      "userId": userId.uid,
      "imageUrl": userData["userImage"],
    });
    _messageController.clear();
    setState(() {
      message = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.all(7),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: "Message ......"),
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: message!.trim() == "" ? null : _sentMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
