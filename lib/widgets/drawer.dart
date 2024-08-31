import 'package:flutter/material.dart';
import 'package:myapp/pages/API.dart';
import 'package:myapp/pages/about.dart';
import 'package:myapp/pages/settings.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Icon(Icons.electric_bolt_rounded),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: (){
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    Settings()
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text("About Us"),
             onTap: (){
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    About()
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text("API"),
             onTap: (){
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    Api()
                )
              );
            },
          )
        ],
      ),
    );
  }
}