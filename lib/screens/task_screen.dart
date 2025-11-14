import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task_item.dart';

class TaskScreen extends StatefulWidget {
  final TaskItem? task;

  const TaskScreen({super.key, this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _titleController = TextEditingController();
  String _priority = "Medium";
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();


    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _priority = widget.task!.priority;
      _descriptionController.text = widget.task!.description;
    }
  }

  void saveTask() async {
    if (widget.task == null) {
      // new task
      final newTask = TaskItem(
        title: _titleController.text.trim(),
        priority: _priority,
        description: _descriptionController.text.trim(),
      );
      await DatabaseHelper.instance.insertTask(newTask);
    } else {
      // Update the existing task
      final updatedTask = TaskItem(
        id: widget.task!.id,
        title: _titleController.text.trim(),
        priority: _priority,
        description: _descriptionController.text.trim(),
      );
      await DatabaseHelper.instance.updateTask(updatedTask);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),

            const SizedBox(height: 12),

            // dropdown to choose priority level
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(labelText: "Priority"),
              items: const [
                DropdownMenuItem(value: "High", child: Text("High")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "Low", child: Text("Low")),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveTask,
              child: Text(widget.task == null ? "Save Task" : "Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}

