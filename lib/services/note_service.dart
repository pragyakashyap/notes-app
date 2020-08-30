import 'package:notes_app/models/api_response.dart';
import 'package:notes_app/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:notes_app/models/note_insert.dart';

class NoteService{
  static const API ='https://notes-app-k.herokuapp.com/notes';


  Future<APIResponse<List<NoteForListing>>> getNotesList()async{
    return  await http.get(API)
    .then((data) {
      if(data.statusCode==200){
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for(var item in jsonData){
          notes.add(NoteForListing.fromjson(item));
          
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(error: true,errmessage: "An error occur");

    })
    .catchError((_)=>APIResponse<List<NoteForListing>>(error: true,errmessage: "An error occuring"));

}

Future<APIResponse<NoteForListing>> getNote(String id)async{
    return  await http.get(API+'/'+id)
    .then((data) {
      if(data.statusCode==200){
        final jsonData = json.decode(data.body);
        return APIResponse<NoteForListing>(data: NoteForListing.fromjson(jsonData));
      }
      return APIResponse<NoteForListing>(error: true,errmessage: "An error occur");

    })
    .catchError((_)=>APIResponse<NoteForListing>(error: true,errmessage: "An error occuring"));

}

static const headers = {
  'Content-Type':'application/json'
};


Future<APIResponse<bool>> createNote(NoteInsert item)async{
    return  await http.post(API,headers: headers,body: json.encode(item.toJson()))
    .then((data) {
      if(data.statusCode==200){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true,errmessage: "An error occur");

    })
    .catchError((_)=>APIResponse<bool>(error: true,errmessage: "An error occuring"));

}


Future<APIResponse<bool>> updateNote(String id , NoteInsert item)async{
    return  await http.put(API+'/'+id,headers: headers,body: json.encode(item.toJson()))
    .then((data) {
      if(data.statusCode==200){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true,errmessage: "An error occur");

    })
    .catchError((_)=>APIResponse<bool>(error: true,errmessage: "An error occuring"));

}

Future<APIResponse<bool>> deleteNote(String id)async{
    return  await http.delete(API+'/'+id,headers: headers)
    .then((data) {
      if(data.statusCode==200){
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true,errmessage: "An error occur");

    })
    .catchError((_)=>APIResponse<bool>(error: true,errmessage: "An error occuring"));

}

}