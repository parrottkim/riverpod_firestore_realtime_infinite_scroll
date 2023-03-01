import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_firestore_realtime_pagination/model/comment.dart';
import 'package:riverpod_firestore_realtime_pagination/pages/controller/home_controller.dart';

class CommentListItem extends ConsumerWidget {
  const CommentListItem({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(commentProvider.notifier);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) => notifier.removeComment(comment.id!),
      child: ListTile(
        title: Text(comment.text),
        subtitle: Text(comment.title),
      ),
    );
  }
}
