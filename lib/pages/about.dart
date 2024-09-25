import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/sizeConfig.dart';
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
        title: const Text("About Us"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left:8, right: 8, bottom: 8),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Center(child: Icon(Icons.info_outlined, size: SizeConfig.defaultTitleSize * 15,)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                     text: "Rams FTC Scouter",
                     style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                    ),
                    TextSpan(
                      text: " is a minimalistic archiver that stores and dynamically updates relevent information about FTC (FIRST Tech Challenge) teams and events. The app is designed to be catered towards all robotics teams and their mentors, as all team/event information is accessible to everyone. Search up events and teams, view all of a team's events for a year, or find out the rankings, schedule, and awards of each event. This app would not be possible without up to date information from the ",
                      style: TextStyle(color: Colors.black, fontSize:  SizeConfig.defaultFontSize)
                    ),
                    TextSpan(
                      text: "FIRST Tech Challenge API.",
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize:  SizeConfig.defaultFontSize),
                      recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          launchUrl(Uri.parse('https://ftc-events.firstinspires.org/services/API'), mode: LaunchMode.externalApplication);
                        }
                    ),
                  ] 
                )
              ),
              Container(height:15),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                     text: "Rams FTC Scouter",
                     style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize:  SizeConfig.defaultFontSize)
                    ),
                    TextSpan(
                      text: " is a solo project created by a programmer on the 16488 (Rams Robotics) team, which is based in Thornhill, Canada.",
                      style: TextStyle(color: Colors.black, fontSize:  SizeConfig.defaultFontSize)
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