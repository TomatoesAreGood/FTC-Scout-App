import 'package:flutter/material.dart';
import 'package:myapp/data/sizeConfig.dart';

class ReportProblem extends StatelessWidget {
  const ReportProblem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text("Report a problem"),
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
                    text:"Report any problems at: ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  TextSpan(
                    text:"jonwu333@gmail.com",
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  TextSpan(
                    text:". Make sure to describe the problem as much as possible. If the error occurs on a team or event page, provide the year, as well as the name associated with it.",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                ]
              ),
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
            RichText(
              text: TextSpan(
                text:"I will try my best to resolve each issue, but please be patient with my response. ",
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: SizeConfig.defaultFontSize)
              ),
            ),
        
            
          ],
        ),
      ),
    );
  }
}