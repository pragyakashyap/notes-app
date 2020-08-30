import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_app/models/note_for_listing.dart';
import 'package:notes_app/models/note_insert.dart';
import 'package:notes_app/services/note_service.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class Note extends StatefulWidget {
  final String id;
  Note({this.id});

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  bool get isEditing => widget.id != null;

  NoteService get service => GetIt.instance<NoteService>();

  String errormessage;
  NoteForListing noteForListing;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });

      service.getNote(widget.id).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errormessage = response.errmessage ?? "Error occuring";
        }
        noteForListing = response.data;
        _titleController.text = noteForListing.title;
        _contentController.text = noteForListing.content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        centerTitle: true,
        gradient: LinearGradient(colors: [Colors.teal, Colors.blueAccent]),
        leading: Padding(
          padding: const EdgeInsets.all(17.5),
          child: Icon(
            Icons.edit,
            color: Colors.blueGrey[900],
          ),
        ),
        title: Text(
          isEditing ? "Edit Note" : "Add Note",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            //color: Colors.blueGrey[900]
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  Container(height: 10),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  Container(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NoteButton(
                        "Save",
                        Colors.blue,
                        () async {
                          //Navigator.pop(context);
                          if (isEditing) {
                            //update Note
                            setState(() {
                              _isLoading = true;
                            });

                            final note = NoteInsert(
                                title: _titleController.text,
                                content: _contentController.text);
                            final result =
                                await service.updateNote(widget.id, note);

                            setState(() {
                              _isLoading = false;
                            });

                            final title = 'Saving...';
                            final text = result.error
                                ? (result.errmessage ?? "Error occured")
                                : "Note updated !";

                            showDialog(
                                barrierColor: Colors.blueGrey[800],
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Colors.blueGrey[200],
                                      titlePadding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      title: Center(
                                        child: Text(
                                          title,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                      content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                      fontSize: 19.5
                                    ),
                                        
                                        ),
                                      )
                                    ],
                                  ),
                                      actions: <Widget>[
                                        FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          color: Colors.blue,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                fontSize: 15,
                                                ),
                                          ),
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            final note = NoteInsert(
                                title: _titleController.text,
                                content: _contentController.text);
                            final result = await service.createNote(note);

                            setState(() {
                              _isLoading = false;
                            });

                            final title = 'Saving...';
                            final text = result.error
                                ? (result.errmessage ?? "Error occured")
                                : "Note created !";

                            showDialog(
                              barrierColor: Colors.blueGrey[800],
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Colors.blueGrey[200],
                        
                                      titlePadding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      title: Center(child: Text(title,style: TextStyle(
                                          fontSize: 25,),)),
                                      content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                      fontSize: 19.5
                                    ),
                                        ),
                                      )
                                    ],
                                  ),
                                      actions: <Widget>[
                                        FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        color: Colors.blue,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                      ),
                      _NoteButton("Discard", Colors.grey[400], () {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(
    this._text,
    this._color,
    this._onPressed,
  );
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: _onPressed,
      child: Text(_text, style: TextStyle(color: Colors.white)),
      color: _color,
    );
  }
}

// widget.id != null?
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child:_NoteButton("Delete", Colors.red,(index)async{
//                   //Navigator.pop(context);
//                    final result = await showDialog(
//                       context: context, builder: (_) => DeleteNote());
//                   if (result) {
//                     final deletedResult =
//                         await service.deleteNote(_apiResponse.data[index].id);

//                     var message;
//                     if (deletedResult != null && deletedResult.data == true) {
//                       message = "The Note was deleted successfully";
//                     } else {
//                       message = deletedResult.errmessage ?? 'Error Occured';
//                     }

//                     showDialog(
//                       context: context,builder: (_) => AlertDialog(
//                         title: Text('Deleting...'),
//                         content: Text(message),
//                         actions: [
//                           FlatButton(onPressed: (){
//                             Navigator.of(context).pop();
//                           }, child: Text('OK'))
//                         ],
//                       )

//                     );

//                         return deletedResult ?.data ?? false;
//                   }

//                   return result;
//                 }),
//               ):Container()
