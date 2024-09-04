import 'package:flutter/material.dart';
import 'package:myapp/data/sizeConfig.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text("Settings"),
      ),
      body: Center(child: Text("Nothing here yet", style: TextStyle(fontSize: SizeConfig.defaultFontSize),)),
    );
  }
}