import 'package:flutter/material.dart';
import 'package:todo_app_exam/dbhelper/dbhelper.dart';
import 'package:todo_app_exam/model/task.model.dart';
import 'package:todo_app_exam/screens/taskscreen/taskform.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
Color colorstate = Colors.green;
String tilestate = '';
  List<Task> _tasks=[];
  @override
  void initState(){
  super.initState();
  _loadTask();
  autoChange();
  }

  Future<void> autoChange() async {
  await Future.delayed(Duration(milliseconds: 2000));
  setState(() {
    colorstate = Colors.orange;
  });
    await Future.delayed(Duration(milliseconds: 2000));
  setState(() {
    colorstate = Colors.red;
    tilestate = 'overdue';
  });
} 
void resetcolor() {
setState(() {
    colorstate = Colors.green;
  });
}

  Future<void> _loadTask() async{
    final tasks = await DatabaseHelper().getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _openForm(Task? task) async {
    final refreshed = await Navigator.push<bool>(context,MaterialPageRoute(builder: (_) => TaskScreenForm(task: task)));
    if(refreshed == true) _loadTask();resetcolor();autoChange();
  }
  Future<void> _deleteTask(int id) async{
    await DatabaseHelper().deleteTask(id);
    _loadTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Task'),
        centerTitle: false,
      ),
      body: _tasks.isEmpty
      ? Center(child: Text('No task on the List'),)
      : ListView.separated(
        itemCount: _tasks.length,
        separatorBuilder: (_,_) => const Divider(height: 1,), 
        itemBuilder: (_,i){
          final task = _tasks[i];
          return ListTile(
            tileColor:colorstate ,
  
            leading: Checkbox(
              value: task.isDone, 
              onChanged: (val)async{
                task.isDone = val!;
                await DatabaseHelper().updateTask(task);_loadTask();
                }),
            title: Text(
              task.title,
              
              ),
              subtitle: Text(tilestate,style: TextStyle(fontSize: 10),),
            onTap: ()=> _openForm(task),
            trailing: IconButton(onPressed: (){_deleteTask(task.id!);}, icon: Icon(Icons.delete)),
          );
        }, 
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=> _openForm(null),child: Icon(Icons.add),),
    );
  }
}