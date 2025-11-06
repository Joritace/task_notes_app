import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> sampleTasks = ["Buy groceries", "Read Flutter book", "Practice SQL"];
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text("My Tasks & Notes")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Welcome to Task Manager", style: TextStyle(fontSize: 20)),
            ),
            SwitchListTile(
              title: Text("Dark Theme"),
              value: isDarkMode,
              onChanged: _toggleTheme,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sampleTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(sampleTasks[index]),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskScreen()),
            );
          },
        ),
      ),
    );
  }
}
