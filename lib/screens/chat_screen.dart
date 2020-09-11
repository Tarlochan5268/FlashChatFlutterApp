import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static String ID = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = Firestore.instance;
  final _auth = Auth.FirebaseAuth.instance;
  Auth.User loggedInUser;
  String messageText;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("email -> ");
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /*void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print("messages received ->");
      print(message.data());
    }
  }
*/
  void getMessageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print("message Receiving ->");
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //getMessages();
    getMessageStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                print("User Sign Out");
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data.docs;
                  List<Text> messageWidgets = [];
                  messages.forEach((message) {
                    final messageText =
                        message.data().values.elementAt(1).toString();
                    final messageSender =
                        message.data().values.elementAt(0).toString();
                    print(messageText);
                    print(messageSender);
                    final messageWidget =
                        Text('$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  });
                  return Column(
                    children: messageWidgets,
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
