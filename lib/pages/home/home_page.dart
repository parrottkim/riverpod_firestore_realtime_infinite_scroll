import 'package:flutter/material.dart';
import 'package:riverpod_firestore_realtime_pagination/pages/widgets/comment_dialog.dart';
import 'package:riverpod_firestore_realtime_pagination/pages/widgets/comment_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('목록'), actions: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CommentDialog(),
          ),
          icon: Icon(Icons.add),
        )
      ]),
      body: CommentList(),
    );
  }
}
