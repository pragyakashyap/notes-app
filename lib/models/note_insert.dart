import 'package:flutter/foundation.dart';

class NoteInsert{
  String title;
  String content;

  NoteInsert(
    {
      @required this.title,
      @required this.content
    }
  );

  Map<String , dynamic> toJson() {
    return{
      "title":title,
      "content":content

    };
  }
}