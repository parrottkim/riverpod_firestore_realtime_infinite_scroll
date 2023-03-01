import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_firestore_realtime_pagination/model/comment.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final StreamController<List<Comment>> _streamController =
    StreamController<List<Comment>>.broadcast();

class CommentRepository {
  // 각 항목이 제한된 양 (20개)로 이루어진 페이지
  // 예를 들어 전체 문서가 24개인 경우
  // [ [문서1, 문서2, ..., 문서 20], [문서21, 문서 22, ..., 문서 24] ]
  // 다음과 같은 형식으로 목록이 생성됨
  List<List<Comment>> _comments = [];
  DocumentSnapshot? _lastDocument;

  Stream<List<Comment>> listenCommentStream() {
    fetchCommentList();
    return _streamController.stream;
  }

  void fetchCommentList([int limit = 20]) {
    // 제한된 양의 문서 요청 (20개)
    var query = _firestore
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .limit(limit);
    List<Comment> results = [];

    // 마지막 문서가 있으면, 쿼리를 마지막 문서 다음부터 조회하도록 조정
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    // 현재 요청 문서가 속한 페이지 지정
    var currentRequestIndex = _comments.length;

    // listen() 메서드를 이용해 업데이트 구독
    query.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        var comments = event.docs
            .map((element) => Comment.fromFirestore(element))
            .toList();

        // 해당 페이지가 존재하는지 여부
        var pageExists = currentRequestIndex < _comments.length;

        // 페이지가 존재하면, 해당 페이지 업데이트
        if (pageExists) {
          _comments[currentRequestIndex] = comments;
        }
        // 페이지가 존재하지 않으면, 페이지 새로 추가
        else {
          _comments.add(comments);
        }

        // 여러 페이지를 하나의 리스트로 결합
        results = _comments.fold<List<Comment>>(
            [], (initialValue, pageItems) => initialValue..addAll(pageItems));

        // StreamController를 이용해 모든 Comment를 브로드캐스트
        _streamController.add(results);
      }

      // 업데이트된 문서는 존재하지 않는데, 문서가 수정되었을 경우
      if (event.docs.isEmpty && event.docChanges.isNotEmpty) {
        for (final data in event.docChanges) {
          // 수정된 문서의 index가 -1인 경우 (삭제된 문서)
          if (data.newIndex == -1) {
            // 전체 리스트에서 해당 문서 삭제
            results
                .removeWhere((element) => element.id == data.doc.data()?['id']);
          }
        }
        // StreamController를 이용해 모든 Comment를 브로드캐스트
        _streamController.add(results);
      }

      // 마지막 문서 지정
      if (results.isNotEmpty && currentRequestIndex == _comments.length - 1) {
        _lastDocument = event.docs.last;
      }
    });
  }

  // 전체 문서 갯수 로드
  Future<int> commentTotalCount() async {
    AggregateQuerySnapshot query = await _firestore
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .count()
        .get();
    return query.count;
  }
}
