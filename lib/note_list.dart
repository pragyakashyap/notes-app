import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes_app/models/note_for_listing.dart';
import 'package:notes_app/services/note_service.dart';
import 'note.dart';
import 'views/note_delete.dart';
import 'package:get_it/get_it.dart';
import 'models/api_response.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.instance<NoteService>();
  APIResponse<List<NoteForListing>> _apiResponse;
  bool _isloading = false;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isloading = true;
    });
    _apiResponse = await service.getNotesList();
    setState(() {
      _isloading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     //backgroundColor: Color.fromRGBO(48, 137, 171, 2),
      appBar: GradientAppBar(
        centerTitle: true,
        gradient: LinearGradient(colors: [Colors.blueAccent, Colors.teal]),
        leading: Padding(
          padding: const EdgeInsets.all(19.5),
          child: Icon(Icons.speaker_notes, color: Colors.blueGrey[900]),
        ),
        //backgroundColor: Colors.teal[500],
        title: Text(
          'Notes',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFC2E9FB),Color(0xFF2EB0BE)],
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          stops: [0.0,1.0],
          tileMode: TileMode.clamp
        
          )
        ),
        child: Builder(
          builder: (_) {
            if (_isloading) {
              return Center(child: CircularProgressIndicator());
              //return Center(child: Image(image : NetworkImage('https://media.giphy.com/media/N256GFy1u6M6Y/giphy.gif',),fit: BoxFit.contain,));
            }
            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errmessage));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(_apiResponse.data[index].id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      final result = await showDialog(
                       // child: CircularProgressIndicator(),
                          context: context, builder: (_) => DeleteNote());
                      if (result) {
                        // setState(() {
                        //   _isloading = true;
                        // }); 
                        final deletedResult =
                            await service.deleteNote(_apiResponse.data[index].id);
                        // setState(() {
                        //   _isloading = false;
                        // });

                        var message;
                        if (deletedResult != null && deletedResult.data == true) {
                          message = "The Note was deleted successfully ..";
                          //_isloading = true;
                        } else {
                          message = deletedResult.errmessage ?? 'Error Occured';
                        }

                        showDialog(
                          barrierColor: Colors.blueGrey[800],
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.blueGrey[200],
                              contentPadding: EdgeInsets.only(top: 16),
                              //titlePadding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0))),
                              // title: Center(
                              //   child: Text(
                              //     'Deleting...',
                              //     style: TextStyle(
                              //         fontSize: 25, color: Colors.red[900],fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              content:
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: 
                                    Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 19.5,
                                        //fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  //Icon(Icons.done)
                                ]
                             ),
                              actions: [
                                FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'))
                              ],
                            ));

                        return deletedResult?.data ?? false;
                      }

                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Note(id: _apiResponse.data[index].id)))
                            .then((data) {
                          _fetchNotes();
                        });
                      },
                      child: Card(
                        //color:Color(0xFF333366),
                        color: Colors.blueGrey[200],
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Icon(Icons.note,color: Colors.black,),
                                    //SizedBox(width: 10,),
                                    Text(
                                      _apiResponse.data[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        fontFamily: 'fonts/Oswald-SemiBold.ttf'
                                      ),
                                    ),
                                    // SizedBox(width: 20,),
                                    Icon(
                                      Icons.note,
                                      color: Colors.black,
                                    ),
                                    //Icon(Icons.keyboard_arrow_right),
                                  ],
                                ),
                                Container(height: 8),
                                Text(
                                  _apiResponse.data[index].content,
                                  style: TextStyle(color: Colors.black,
                                  fontFamily: 'fonts/Oswald-Regular.ttf'
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                    ),
                  );
                },
                itemCount: _apiResponse.data.length,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Create a Note',
        backgroundColor: Colors.blueAccent[800],
        hoverColor: Colors.white,
        hoverElevation: 6.0,
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Note()))
              .then((_) {
            _fetchNotes();
          });
        },
        icon: Icon(Icons.note_add),
        label: Text('Create Note'),
      ),
    );
  }
}
