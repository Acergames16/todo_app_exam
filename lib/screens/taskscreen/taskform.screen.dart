import 'package:flutter/material.dart';
import 'package:todo_app_exam/dbhelper/dbhelper.dart';
import 'package:todo_app_exam/model/task.model.dart';

class TaskScreenForm extends StatefulWidget {
  final Task? task;

  const TaskScreenForm({super.key, required this.task});

  @override
  State<TaskScreenForm> createState() => _TaskScreenFormState();
}

class _TaskScreenFormState extends State<TaskScreenForm> {
  late TextEditingController _titleController;

bool get isEditing => widget.task?.isDone != null;
  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
  }

  Future<void> _save() async {
      final title = _titleController.text.trim();
      if(title.isEmpty) return;

      if(isEditing){
        await DatabaseHelper().updateTask(
          Task(id: widget.task!.id, title: title, isDone: widget.task!.isDone)
        );
      }else{
        await DatabaseHelper().insertTask(
          Task(title: title)
        );
      }
      if(mounted) Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Title'),
        actions: [
          IconButton(onPressed: _save, icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "TITLE",
            ),
          )
        ],
      ),

    );
  }
}