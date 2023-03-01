// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromFirestore(QueryDocumentSnapshot<Map> doc) => Comment(
      id: doc.id,
      title: doc.data()['title'] as String,
      text: doc.data()['text'] as String,
      createdAt: doc.data()['createdAt'].toDate(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'createdAt': instance.createdAt,
    };
