import 'package:flutter/material.dart';
import 'todo.dart';

class NewSubject extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewSubjectState();
  }
}

class NewSubjectState extends State<StatefulWidget> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController subjectTodo = TextEditingController();
  TodoProvider db = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: subjectTodo,
              decoration: InputDecoration(labelText: 'Subject'),
              style: TextStyle(fontSize: 16,color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill subject";
                }
              },
            ),
            RaisedButton(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                _formkey.currentState.validate();
                if (subjectTodo.text.length > 0) {
                  await db.open("todo.db");
                  Todo todo = Todo();
                  todo.title = subjectTodo.text;
                  todo.done = false;
                  await db.insert(todo);
                  print(todo);
                  Navigator.pop(context, true);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}