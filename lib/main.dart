import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_app/services/note_service.dart';
import 'note_list.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(() => NoteService());
}
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Notes",
      home:
      NoteList(),
      );
      
    
  }
}