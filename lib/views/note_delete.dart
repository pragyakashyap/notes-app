import 'package:flutter/material.dart';
//import 'package:giffy_dialog/giffy_dialog.dart';

class DeleteNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[200],
      titlePadding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
      title: Center(child: Text("Confirmation",style: TextStyle(
                              color: Colors.red[900]
                            ),)),
                            
      content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : <Widget>[
                Icon(Icons.delete),
                Expanded(
                  child: Text(
                    'Do you want to delete ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //color: Colors.teal[600],
                      fontSize: 19.0,
                      //fontWeight: FontWeight.bold

                    ),
                  ),
                )
              ],
            ),
      actions:<Widget>[
        FlatButton(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),

          color: Colors.grey[700],
          child: Text(
            "Yes",
            style: TextStyle( fontSize: 19),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        SizedBox(width: 3.0,),
        FlatButton(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
          color: Colors.red,
          child: Text(
            "No",
            style: TextStyle(fontSize: 19,)
          ),
          onPressed: () => Navigator.of(context).pop(false),
        )
      ],
    );
  }
}

