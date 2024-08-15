import 'package:flutter/material.dart';


class EventSubpage extends StatefulWidget {
  final String code;

  const EventSubpage({super.key, required this.code});

  @override
  State<EventSubpage> createState() => _EventSubpageState();
}

class _EventSubpageState extends State<EventSubpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ahjklsfjnhklsfa"),
        actions: [
          IconButton(onPressed: (){print("favouited");}, icon: Icon(Icons.star_border))
        ],
      ),
      body: Center(child: Text("event code: ${widget.code}")),
    );
  }
}