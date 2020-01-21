import 'package:flutter/material.dart';
import 'package:gif_search/pages/gifPage.dart';
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
          "https://api.giphy.com/v1/gifs/search?api_key=fyRlKCIH7jEoFEOO457SyEMCNWOUjPHu&q=$_search&limit=9&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  int _getCount(List data){
    
    if(_search == null){
      return data.length;
    }
    else{
      return data.length + 1;
    }
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
                        onSubmitted: (text){
                          setState(() {
                            _search = text;
                            _offset = 0;
                          });
                        },
                      ),
            );
  }

  Widget gridGif(){
    return Expanded(
      child: FutureBuilder(
        future: _getGifs(),
        builder: (context, snapshot){
          
          switch(snapshot.connectionState){            
            case ConnectionState.none:              
            case ConnectionState.waiting:
              return Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5,
                ),
              );
            default:
              if(snapshot.hasError) 
                return Container();
              else 
                return _createGifTable(context, snapshot);
          }          
        },
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                    ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
       
        if(_search == null || index < snapshot.data["data"].length){
          return  GestureDetector(
                    child:  Image.network(
                              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                              height: 300,
                              fit: BoxFit.cover,                          
                            ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
                    },
                  );
        }
        else{         
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70),
                  Text("Loading...", style: TextStyle(color: Colors.white, fontSize: 22))
                ],
              ),
              onTap: () {
                setState(() {
                  _offset+= 9;
                });
              },
            ),
          );
        }        
      },
    );
  }

  Column col() {
    return Column(
      children: <Widget>[
        searchWidget(),
        gridGif()
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
