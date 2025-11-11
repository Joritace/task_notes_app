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

  // ✅ Fetch tasks from SQLite
  void loadTasks() async {
    final data = await DatabaseHelper.instance.fetchTasks();
    setState(() {
      tasks = data;
    });
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ✅ Theme Switch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile(
                title: const Text("Dark Mode"),
                value: isDark,
                onChanged: (value) {
                  widget.onToggleTheme();
                },
              ),
            ),

            const SizedBox(height: 8),

            // ✅ Show tasks from database
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Text(
                  "No tasks yet. Tap + to add one.",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(task.priority),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper.instance
                              .deleteTask(task.id!);

                          loadTasks();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Add new task button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskScreen()),
          );

          // ✅ Refresh once user returns from TaskScreen
          loadTasks();
        },
      ),
    );
  }
}
