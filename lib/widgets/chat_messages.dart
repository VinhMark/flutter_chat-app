import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('No messages found.'));
          }
        }

        if (chatSnapshot.hasError) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Something went wrong...'));
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: chatSnapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final chatMessage = chatSnapshot.data!.docs[index].data();
            final nextChatMessage = index + 1 < chatSnapshot.data!.docs.length
                ? chatSnapshot.data!.docs[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = currentMessageUserId == nextMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: currentMessageUserId == authenticatedUser!.uid);
            }
            return MessageBubble(
                username: chatMessage['username'],
                userImage: chatMessage['userImage'],
                message: chatMessage['text'],
                isMe: currentMessageUserId == authenticatedUser!.uid);
          },
        );
      },
    );
  }
}
