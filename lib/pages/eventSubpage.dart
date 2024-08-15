import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/sizeConfig.dart';


class EventSubpage extends StatefulWidget {
  final String code;
  final String name;

  const EventSubpage({super.key, required this.name, required this.code});

  @override
  State<EventSubpage> createState() => _EventSubpageState();
}

class _EventSubpageState extends State<EventSubpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(widget.name)
              )
            ),
          ]
        ),
        actions: [
          IconButton(onPressed: (){print("favouited");}, icon: Icon(Icons.star_border))
        ],
      ),
      body: Center(child: Text("event code: ${widget.code}")),
    );
  }
}