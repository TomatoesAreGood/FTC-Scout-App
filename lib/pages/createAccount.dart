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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating a new account"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
           RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "1. Click on ",
                    style: TextStyle(color: Colors.black, fontSize:  SizeConfig.defaultFontSize)
                  ),
                  TextSpan(
                    text: "this link",
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize:  SizeConfig.defaultFontSize),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        launchUrl(Uri.parse('https://ftc-events.firstinspires.org/services/API/register'), mode: LaunchMode.externalApplication);
                      }
                  ),
                  TextSpan(
                     text: " and follow the instructions on the website to register for an API developer account. Enter accurate and relevant information.",
                     style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  TextSpan(
                    text: " An email will be sent containing your log in credentials. DO NOT share your token or user with other people. You shouldn't have to sign in multiple times, but save your token and user in a secure location in case",
                    
                  ),
                ] 
              )
            ),
        ],
      ),
    );
  }
}