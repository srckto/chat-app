import 'package:flutter/material.dart';

class MessageStyle extends StatelessWidget {
  final String username;
  final String message;
  final bool isMe;
  final Key key;
  final String imageUser;

  const MessageStyle({
    required this.username,
    required this.message,
    required this.isMe,
    required this.key,
    required this.imageUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(imageUser),
          ),
        Container(
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).accentColor.withOpacity(0.95) : Colors.grey.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13),
              topRight: Radius.circular(13),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(13),
              bottomLeft: isMe ? Radius.circular(13) : Radius.circular(0),
            ),
          ),
          width: 140,
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.w600, color: isMe ? Colors.white : Colors.black),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
        if (isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(imageUser),
          ),
      ],
    );
  }
}
