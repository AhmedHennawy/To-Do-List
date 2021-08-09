import 'package:flutter/material.dart';
import './item.dart';
import './database_helper.dart';
import './date_formatter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _editController = new TextEditingController();
  final TextEditingController _editController2 = new TextEditingController();

  var db = new DatabaseHelper();
  final List<Item> _itemList = <Item>[];
  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _submit(String text) async {
    _editController.clear();
    Item item = new Item(text, dateFormatted());
    await db.insertItem(item);
    setState(() {
      _itemList.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("NoToDo"),
        centerTitle: false,
        backgroundColor: Colors.black54,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showForm,
        tooltip: "Add Item",
        backgroundColor: Colors.redAccent,
        child: new Icon(Icons.add),
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    return new Card(
                      color: Colors.white10,
                      child: new ListTile(
                        title: _itemList[index],
                        onLongPress: () =>
                            _updateListItem(_itemList[index], index),
                        trailing: new Listener(
                          key: new Key(_itemList[index].itemName),
                          child: new Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteListItem(_itemList[index].id, index),
                        ),
                      ),
                    );
                  }),
            ),
            new Divider(
              height: 1.0,
            )
          ],
        ),
      ),
    );
  }

  void _showForm() {
    var alert = AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _editController,
              autofocus: true,
              decoration: new InputDecoration(
                  hintText: "eg. Don't buy stuff",
                  labelText: "Item",
                  icon: new Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _submit(_editController.text);
            Navigator.pop(context);
          },
          child: new Text("Save"),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getAllItems();
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(Item.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteListItem(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateListItem(Item item, int index) async {
    var alert = AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _editController2,
              autofocus: true,
              decoration: new InputDecoration(
                  hintText: "eg. Don't buy stuff",
                  labelText: "Item",
                  icon: new Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            Item newItem = new Item.map({
              "itemName": _editController2.text,
              "date": dateFormatted(),
              "id": item.id
            });
            _handleSubmittedUpdate(index, item); //redrawing the screen
            await db.updateItem(newItem); //updating the item
            setState(() {
              _readNoDoList(); // redrawing the screen with all items saved in the db
            });
            Navigator.pop(context);
          },
          child: new Text("Update"),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, Item item) async {
    _editController.clear();
    setState(() {
      _itemList.removeRange(0, _itemList.length);
    });
  }
}
