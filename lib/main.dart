import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load saved theme when the app starts
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkSaved = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkSaved: isDarkSaved));
}

class MyApp extends StatefulWidget {
  final bool isDarkSaved;

  const MyApp({super.key, required this.isDarkSaved});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkSaved; // ✅ Initialize theme from saved prefs
  }

  // ✅ Toggle theme + save it
  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode); // ✅ Save toggle result
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Notes Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onToggleTheme: toggleTheme),
    );
  }
}
