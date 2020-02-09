import 'package:dbonspot/dbclient/dbhelp.dart';
import 'package:dbonspot/model/Item.dart';
import 'package:flutter/material.dart';

class NextScreen extends StatefulWidget {
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  var db = new Databasehelper();
  List<Item> itemList = [];
  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int index) {
          if (itemList != null && itemList.isNotEmpty) {
            return Card(
              child: ListTile(
                  onTap: () {
                    _showContent(itemList[index]);
                  },
                  onLongPress: () {
                    _updateItem(itemList[index], index);
                  },
                  key: UniqueKey(),
                  title: Text(itemList[index].title.toString()),
                  subtitle:
                      Text('Created on ${itemList[index].date.toString()}'),
                  leading: CircleAvatar(
                      child: Text(itemList[index]
                          .title
                          .toString()
                          .substring(0, 1)
                          .toUpperCase())),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _delItem(itemList[index].id);
                        itemList.removeAt(index);
                        setState(() {});
                      })),
            );
          } else {
            return Center(
              child: Text('Nothing To Display Nibba'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  _readData() async {
    final data = await db.getAllItems();
    if (data != null && data.isNotEmpty) {
      data.forEach((item) {
        itemList.add(Item.map(item));
      });
    }
    setState(() {});
  }

  _showDialog() {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _contentController = new TextEditingController();
    var alert = AlertDialog(
      title: Text('Yo! Todo'),
      content: ListView(children: <Widget>[
        TextField(
            controller: _titleController,
            decoration:
                InputDecoration(labelText: 'Title', errorText: 'Required')),
        TextField(
            controller: _contentController,
            decoration:
                InputDecoration(labelText: 'Content', errorText: 'Required')),
      ]),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _contentController.text.isNotEmpty) {
              _handleSubmit(_titleController.text, _contentController.text,
                  DateTime.now().toString().substring(0, 11));
              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            } else {
              var snackbar =
                  SnackBar(content: Text('Item failed to save dude.'));
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(snackbar);
            }
          },
          child: Text('Add'),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _handleSubmit(String title, String content, String date) async {
    Item newItem = Item(title, content, date);
    int savedItem = await db.saveItem(newItem);
    print('Database item saved with id as $savedItem');
    itemList.insert(0, newItem);
    setState(() {});
  }

  _delItem(int id) async {
    await db.deleteItem(id);
    print('Deleted item');
  }

  void _showContent(Item itemList) async {
    var alert = AlertDialog(
      title: Text(
        'Content',
        style: TextStyle(fontSize: 23.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Flexible(child: Text(itemList.content)),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back'),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _updateItem(Item item, int index) {
    TextEditingController _titleEditor = new TextEditingController();
    TextEditingController _contentEditor = new TextEditingController();
    var alert = AlertDialog(
      title: Text(
        'Edit',
        style: TextStyle(fontSize: 23.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleEditor,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
          ),
          TextField(
            controller: _contentEditor,
            decoration: InputDecoration(labelText: 'Content'),
          ),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () async {
            if (_titleEditor.text.isNotEmpty &&
                _contentEditor.text.isNotEmpty) {
              Item updatedItem = new Item.fromMap({
                'id': item.id,
                'title': _titleEditor.text,
                'content': _contentEditor.text,
                'date': item.date
              });
              final result = await db.updateItem(updatedItem);
              print('Data Updated Successfully $result');
              itemList.removeAt(index);
              itemList.insert(index, updatedItem);
              setState(() {});
              Navigator.pop(context);
            } else {
              var snackbar =
                  SnackBar(content: Text('Item failed to update dude.'));
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(snackbar);
            }
          },
          child: Text('Update Data'),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
