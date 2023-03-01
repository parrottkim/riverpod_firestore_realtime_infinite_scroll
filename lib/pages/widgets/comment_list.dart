import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_firestore_realtime_pagination/pages/controller/home_controller.dart';
import 'package:riverpod_firestore_realtime_pagination/pages/widgets/comment_list_item.dart';
import 'package:riverpod_firestore_realtime_pagination/pages/widgets/comment_shimmer.dart';

class CommentList extends ConsumerWidget {
  const CommentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(commentProvider);
    final notifier = ref.watch(commentProvider.notifier);
    return state.when(
      data: (data) => ListView.builder(
        controller: notifier.controller,
        itemCount:
            data.length < notifier.totalCount ? data.length + 1 : data.length,
        itemBuilder: (context, index) {
          if (index != data.length) {
            return CommentListItem(comment: data[index]);
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      loading: () => CommentShimmer(),
      error: (error, stackTrace) => Center(
        child: Text('오류 발생'),
      ),
    );
  }
}
