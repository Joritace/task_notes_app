import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task_item.dart';
import 'task_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskItem> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }
//display the tasks
  void loadTasks() async {
    final data = await DatabaseHelper.instance.fetchTasks();
    setState(() {
      tasks = data;
    });
  }

  void toggleTaskComplete(TaskItem task, bool value) async {
    task.isCompleted = value;
    await DatabaseHelper.instance.updateTask(task);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task & Note Manager"),
        centerTitle: true,
        elevation: 3,
      ),
      body: Container(
        color: isDark ? Colors.black : Colors.grey[200],
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Welcome to Task Manager",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile(
                title: const Text("Mode"),
                value: isDark,
                onChanged: (value) {
                  widget.onToggleTheme();
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Text(
                  "No tasks yet. Tap + to add one.",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ExpansionTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (val) {
                          toggleTaskComplete(task, val!);
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text("Priority: ${task.priority}"),
                      children: [
                        if (task.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              task.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TaskScreen(task: task),
                                  ),
                                );
                                loadTasks();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await DatabaseHelper.instance.deleteTask(task.id!);
                                loadTasks();
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      //button to add tasks
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskScreen()),
          );
          loadTasks();
        },
      ),
    );
  }
}
