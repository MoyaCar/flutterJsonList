import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:vector_math/vector_math_lists.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class Note {
  final int id;
  final int userId;
  final String title;
  final String body;

  Note({this.id, this.userId, this.title, this.body});
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        body: json['body'],
      );
}

class NoteList {
  final List<Note> noteList;

  NoteList({this.noteList});
  factory NoteList.fromJson(List<dynamic> json) {
    List<Note> noteListe = new List<Note>();
    noteListe = json.map((i) => Note.fromJson(i)).toList();
    return NoteList(
      noteList: noteListe,
    );
  }
}

Future<NoteList> buildNote() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts');
  if (response.statusCode == 200) {
    return NoteList.fromJson(json.decode(response.body));
  } else {
    throw Exception('No data');
  }
}

void main() {
  runApp(MyApp(
    noteList: buildNote(),
  ));
}

class MyApp extends StatelessWidget {
  final Future<NoteList> noteList;

  const MyApp({Key key, this.noteList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FutureBuilder(
        future: noteList,
        builder: (context, list) {
          if (list.hasData) {
            return Column(
              children: List.generate(list.data.noteList.length, (index) {
                return Text(list.data.noteList[index].title);
              }),
            );
          }
          return CircularProgressIndicator();
        },
      )),
    );
  }
}
