import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/privacyPolicy.dart';
import 'package:myapp/pages/about.dart';
import 'package:myapp/pages/reportProblem.dart';
import 'package:myapp/pages/settings.dart';
import 'package:myapp/userPreferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              width: double.maxFinite,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color.fromARGB(255, 233, 227, 215),),
                child: Image(image:AssetImage('assets/ScouterLogo1024.png')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: (){
               Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => 
                      const Settings()
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
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Privacy Policy"),
               onTap: (){
               Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => 
                      const PrivacyPolicy()
                  )
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text("Report a Problem"),
               onTap: (){
               Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => 
                      const ReportProblem()
                  )
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Are you sure you want to sign out?", textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          UserPreferences.logOut();
                          setState(() {
                            MyApp.reload(context);
                          });
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}