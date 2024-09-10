import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myapp/data/sizeConfig.dart';
import 'package:myapp/main.dart';
import 'package:myapp/userPreferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.red,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: page(),
      ),
    );
  }

  Widget page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            icon(),
            const SizedBox(height: 40),
            inputField("User", userController),
            const SizedBox(height: 20),
            inputField("Token", tokenController),
            const SizedBox(height: 25),
            loginButton(),
            const SizedBox(height: 10),
            extraText(),
          ],
        ),
      ),
    );
  }

  Widget icon() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle),
      child: Icon(Icons.person, color: Colors.white, size: SizeConfig.defaultFontSize * 12),
    );
  }

  Widget inputField(String hintText, TextEditingController controller,{isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      onChanged: (value){
        setState((){});
      },
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: controller.text.isNotEmpty ? IconButton(onPressed: (){
          setState(() {
            controller.clear();
          });
        }, icon: const Icon(Icons.close, color: Colors.white,)): SizedBox(height: 0),
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Sign in ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  Widget extraText() {
    return TextButton(
      onPressed: (){debugPrint("asjklkljasf");}, 
      child: Text(
        "Create an account",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      )
    );
  }
}