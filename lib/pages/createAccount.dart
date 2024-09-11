import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/sizeConfig.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  Widget generateTitle(String title){
    return Text(
      title,
      style: TextStyle(
        shadows:  const [
          Shadow(
              color: Colors.black,
              offset: Offset(0, -6))
        ],
        color: Colors.transparent,
        decoration:
        TextDecoration.underline,
        decorationColor: Colors.grey,
        decorationThickness: 1,
        fontSize:SizeConfig.defaultTitleSize
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating a new account"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "1. Go to ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  TextSpan(
                    text: "https://ftc-events.firstinspires.org/services/API/register",
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize:  SizeConfig.defaultFontSize),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        launchUrl(Uri.parse('https://ftc-events.firstinspires.org/services/API/register'), mode: LaunchMode.inAppBrowserView);
                      }
                  ),
                  TextSpan(
                      text: " and enter relevent information to register for API access.",
                      style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                ],
              )
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text:"2. An automated email will be sent containing your log in credentials. DO NOT share your token/user with other people.",
                style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
              )
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text:"Note: You shouldn't have to sign in multiple times, but save your token and user in a secure location in case.",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: SizeConfig.defaultFontSize)
              )
            ),
            const SizedBox(height: 20),
            generateTitle("Why is an account needed?"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:"An official FTC API account is needed to access features of this app. This app needs to make calls to the ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  TextSpan(
                      text: "FIRST Tech Challenge API",
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize:  SizeConfig.defaultFontSize),
                      recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          launchUrl(Uri.parse('https://ftc-events.firstinspires.org/services/API'), mode: LaunchMode.inAppBrowserView);
                        }
                  ),
                  TextSpan(
                    text:" in order to receive up to date information about events and teams. This app is not meant to be a stand-alone app, but an extension of the FTC API that visually presents information in a easy-to-read format.",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}