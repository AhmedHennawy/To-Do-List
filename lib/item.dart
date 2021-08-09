import 'package:flutter/material.dart';
class Item extends StatelessWidget {
  String _itemName;
  String _date;
  int _id;
  Item(this._itemName,this._date);
  String get itemName =>_itemName;
  String get date => _date;
  int get id => _id;
  Item.map(dynamic obj){
    this._itemName = obj["itemName"];
    this._date = obj["date"];
    this._id = obj["id"];
  }
  Map<String,dynamic> toMap(){
    var m = new Map<String,dynamic>();
    
    m["itemName"] = _itemName;
    m["date"] = _date;
    if(id != null)
    {m["id"] = _id;}
    return m;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 new Text(_itemName,
                   style: new TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                       fontSize: 16.9
                   ),),

                 new Container(
                   margin: const EdgeInsets.only(top: 5.0),
                   child: new Text("Created on: $_date",
                     style: new TextStyle(
                         color:  Colors.white70,
                         fontSize: 12.5,
                         fontStyle:  FontStyle.italic
                     ),),

                 )


               ],
            ),

          
        ],
      ),
    );
  }
}