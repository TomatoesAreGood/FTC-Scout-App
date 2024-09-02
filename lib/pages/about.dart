import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("About Us"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                     text: "FTC Scouter",
                     style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 15)
                    ),
                    TextSpan(
                      text: " is a minimalistic archiver that stores and dynamically updates relevent information about FTC (FIRST Tech Challenge) teams and events. The app is designed to be catered towards all robotics teams and their mentors, as all team/event information is accessible to everyone. Search up events and teams, view all of a team's events for a year, or find out the rankings, schedule, and awards of each event. This app would not be possible without up to date information from the ",
                      style: TextStyle(color: Colors.black, fontSize: 15)
                    ),
                    TextSpan(
                      text: "FIRST Tech Challenge API.",
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          launchUrl(Uri.parse('https://ftc-events.firstinspires.org/services/API'), mode: LaunchMode.externalApplication);
                        }
                    ),
                  ] 
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}