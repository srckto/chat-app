import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/message_textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DropdownButton(
              
              icon: Icon(Icons.menu, color: Colors.white),
              items: [
                DropdownMenuItem(
                  value: "LogOut",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      const Text("LogOut", style: TextStyle(fontSize: 17)),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == "LogOut") {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor.withOpacity(0.1),
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            MessageTextField(),
          ],
        ),
      ),
    );
  }
}
