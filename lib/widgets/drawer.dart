import 'package:flutter/material.dart';
import 'package:myapp/pages/privacyPolicy.dart';
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
            child: Image(image:AssetImage('assets/logo.png')),
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
            leading: const Icon(Icons.question_mark),
            title: const Text("About Us"),
             onTap: (){
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    const About()
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text("Privacy Policy"),
             onTap: (){
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    PrivacyPolicy()
                )
              );
            },
          )
        ],
      ),
    );
  }
}