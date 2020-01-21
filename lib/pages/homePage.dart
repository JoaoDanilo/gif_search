import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=fyRlKCIH7jEoFEOO457SyEMCNWOUjPHu&limit=20&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=fyRlKCIH7jEoFEOO457SyEMCNWOUjPHu&q=$_search&limit=20&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  Widget searchWidget() {
    return  Padding(
              padding:  EdgeInsets.all(10),
              child:  TextField(
                        decoration: InputDecoration(
                                      labelText: "Search Here",
                                      labelStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder()
                                    ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
            );
  }

  Column col() {
    return Column(
      children: <Widget>[
        searchWidget()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: col());
  }
}
