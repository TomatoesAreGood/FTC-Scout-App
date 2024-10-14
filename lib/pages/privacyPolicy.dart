import 'package:flutter/material.dart';
import 'package:myapp/data/sizeConfig.dart';

class PrivacyPolicy extends StatefulWidget {
   const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final String companyName = "GenericTomatoCompany";
  final String appName = "FTC ScoutMaster";

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
        decoration: TextDecoration.underline,
        decorationColor: Colors.grey,
        decorationThickness: 1,
        fontSize:SizeConfig.defaultTitleSize
      ),
    );
  }

  TextSpan company(){
    return TextSpan(
      text: companyName,
      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: SizeConfig.defaultFontSize)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title:  const Text("Privacy Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ListView(
          children: [
            SizedBox(height: SizeConfig.defaultFontSize),
            generateTitle("Introduction"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Our privacy policy will help you understand what information we collect at ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  company(),
                   TextSpan(
                    text: ", how ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  company(),
                   TextSpan(
                    text: " uses it, and what choices you have. ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  company(),
                  TextSpan(
                    text: " built the $appName app as a free app. ",
                    style:  TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                   TextSpan(
                    text: "This SERVICE is provided by ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  company(),
                   TextSpan(
                    text: " at no cost and is intended for use as is. If you choose to use our Service, then you agree to the privacy policy located on this page, including any amendments that ",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                  company(),
                   TextSpan(
                    text: " makes in the future.",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)
                  ),
                   TextSpan(
                    text: " We do NOT collect or share personal information.",
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize, fontWeight: FontWeight.bold )
                  ),
                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
            generateTitle("Third Parties"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "We do not exchange your personal information with any third parties.", style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize))
                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
            generateTitle("Location Information"),
            RichText(
              text:  TextSpan(
                children: [
                  TextSpan(text: "No location information is collected or stored from any users of the app.", style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize))
                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
            generateTitle("Device Information"),
            RichText(
              text:  TextSpan(
                children: [
                  TextSpan(text: "We collect information from your device in some cases. The information will be utilized for the provision of better service and to prevent fraudulent acts. Additionally, such information will not include that which will identify the individual user.", style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize))
                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
            generateTitle("Cookies"),
            RichText(
              text:  TextSpan(
                children: [
                  TextSpan(text: 'Cookies are files with small amount of data that is commonly used an anonymous unique identifier. These are sent to your browser from the website that you visit and are stored on your devices’s internal memory. ', style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize)),
                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize,),
            RichText(
              text:  TextSpan(
                children: [
                  TextSpan(text: 'This Service does not uses these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collection information and to improve their services. You have the option to either accept or refuse these cookies, and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.', style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize))                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
            generateTitle("Changes to This Privacy Policy"),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately, after they are posted on this page.", style: TextStyle(color: Colors.black, fontSize: SizeConfig.defaultFontSize))
                ]
              )
            ),
            SizedBox(height: SizeConfig.defaultFontSize),
          ],
        ),
      ),
    );
  }
}