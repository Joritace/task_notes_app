import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleController, decoration: InputDecoration(labelText: "Title")),
              TextFormField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Insert into database
                    Navigator.pop(context);
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
