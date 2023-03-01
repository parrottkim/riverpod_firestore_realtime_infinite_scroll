import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String? id;
  final String title, text;
  final DateTime createdAt;

  Comment({
    this.id,
    required this.title,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromFirestore(QueryDocumentSnapshot<Map> doc) =>
      _$CommentFromFirestore(doc);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
