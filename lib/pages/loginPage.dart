import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:myapp/data/sizeConfig.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/createAccount.dart';
import 'package:myapp/userPreferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: page(),
      ),
    );
  }

  Widget page() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Text("Login", style: TextStyle(fontSize: SizeConfig.defaultTitleSize * 2, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("A free FTC API account is needed to access this app. This sign-up is a one time thing.", style: TextStyle(fontSize: SizeConfig.defaultFontSize), textAlign: TextAlign.center),
              const SizedBox(height: 35,),
              icon(),
              const SizedBox(height: 40),
              inputField("User", userController),
              const SizedBox(height: 20),
              inputField("Token", tokenController),
              const SizedBox(height: 40),
              loginButton(),
              const SizedBox(height: 10),
              extraText(),
          ],
          )
        ),
      ),
    );
  }

  Widget icon() {
    return Stack(
      children: [
        Container(
          width: SizeConfig.defaultFontSize * 12,
          height: SizeConfig.defaultFontSize * 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
        Icon(
          MingCute.user_1_line,
          size: SizeConfig.defaultFontSize * 12,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget inputField(String hintText, TextEditingController controller) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.black));

    var selectedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(
        width: 2,
        color: Colors.blue
      ),
    );

    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      onChanged: (value){
        setState((){});
      },
      decoration: InputDecoration(
        prefixIcon: hintText == "User" ? const Icon(Icons.person): const Icon(Icons.key),
        hintText: hintText,
        suffixIcon: controller.text.isNotEmpty ? IconButton(onPressed: (){
          setState(() {
            controller.clear();
          });
        }, icon: const Icon(Icons.close, color: Colors.black,)): const SizedBox(height: 0),
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: border,
        focusedBorder: selectedBorder,
      ),
    );
  }

  Future<bool> checkValidCredentials(String token, String user) async {
    if(token.isEmpty || user.isEmpty){
      return false;
    }

    String authorization = "$user:$token";
    String encodedToken = base64.encode(utf8.encode(authorization));

    final response = await http.get(Uri.parse('https://ftc-api.firstinspires.org/v2.0/2021'), headers: {"Authorization": "Basic $encodedToken"});

    if(response.statusCode == 200){
      return true;
    }
    return false;
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: () async {
        if(await checkValidCredentials(tokenController.text, userController.text)){
          UserPreferences.setSavedToken(tokenController.text);
          UserPreferences.setSavedUser(userController.text);
          setState(() {
            MyApp.reload(context);
          });
        }else{
          return showDialog(
            context: context,
            builder: (BuildContext context) => 
              AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: const Text("Invalid user/token", maxLines: 2,textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ],
              )
          );
        }

      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.lightBlue[300],
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const SizedBox(
          width: 125,
          child: Text(
            "Log in ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }

  Widget extraText() {
    return TextButton(
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => 
              const CreateAccount()
          )
        );
      }, 
      child: const Text(
        "Create an account",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black),
      )
    );
  }
}