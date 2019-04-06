import 'package:flutter/material.dart';
import 'add.dart';
import 'todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     initialRoute: '/',
     routes: {
       '/': (context) => TaskScreen(),
     },
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskScreenState();
  }
}

class TaskScreenState extends State {
  bool test = false;
  int _current_state = 0;
  int countTodo = 0;
  int countDone = 0;
  List<Todo> todolist;
  List<Todo> todoDoneList;

  TodoProvider db = TodoProvider();
  @override
  void getTodoList() async {
    await db.open("todo.db");
    db.getAllTodos().then((todolist) {
      setState(() {
        this.todolist = todolist;
        this.countTodo = todolist.length;
      });
    });
    db.getAllDoneTodos().then((todoDoneList) {
      setState(() {
        this.todoDoneList = todoDoneList;
        this.countDone = todoDoneList.length;
      });
    });
  }

  Widget build(BuildContext context) {
    List current_tab = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewSubject()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          db.deleteAllDoneTodo();
        },
      )
    ];

    List current_screen = [
      // task_screen
      countTodo == 0
          ? Text("No data found..")
          : ListView.builder(
              itemCount: countTodo,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                      color: Colors.black,
                    ),
                    ListTile(
                      title: Text(
                        this.todolist[position].title,
                        style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                      ),
                      trailing: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              todolist[position].done = value;
                            });
                            db.update(todolist[position]);
                          },
                          value: todolist[position].done),
                    )
                  ],
                );
              },
            ),
      // complete screen
      countDone == 0
          ? Text("No data found..")
          : ListView.builder(
              itemCount: countDone,
              itemBuilder: (context, int position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                      color: Colors.black,
                    ),
                    ListTile(
                      title: Text(
                        this.todoDoneList[position].title,
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      trailing: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              todoDoneList[position].done = value;
                            });
                            db.update(todoDoneList[position]);
                          },
                          value: todoDoneList[position].done),
                    )
                  ],
                );
              },
            ),
    ];
    getTodoList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _current_state == 0 ? current_tab[0] : current_tab[1]
          ],
          backgroundColor: Colors.orangeAccent,
        ),
        body: Center(
            child: _current_state == 0 ? current_screen[0] : current_screen[1]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current_state,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Task')),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text('Complete'))
          ],
          onTap: (int index) {
            setState(() {
              _current_state = index;
            });
          },
        ),
      ),
    );
  }
}
class _SecondScreenState extends State<SecondScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: MyCustomForm()
    //   Center(
    //     child:Column(
    //     children: <Widget>[
    //     TextFormField(
    //       validator: (value){
    //       if (value.isEmpty){
    //         return 'Please fill subject';
    //       }

    //       },
    //       decoration: InputDecoration(
    //       labelText: 'Subject'),
    //   ),
    //     RaisedButton(
    //       onPressed: (){ 
    //         if (_formKey.currentState.validate()){
    //           Scaffold.of(context).showSnackBar(SnackBar(content: Text('process')));
    //         }
    //       },
    //       child: const Text('Save'),
    //     )
    //     ]
    //   )
    // )
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please fill subject';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  Navigator.pushNamed(context, '/');
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
