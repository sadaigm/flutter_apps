import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MainPage());
MaterialColor green = Colors.green;
MaterialColor blue = Colors.blue;
getText(text, s) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: 'Quicksand', fontSize: s, fontWeight: FontWeight.bold),
  );
}

gS(h, w) {
  return SizedBox(
    height: h,
    width: w,
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieApp(),
    );
  }
}

class MovieApp extends StatefulWidget {
  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  MovieDB moviedb;
  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  void loadMovies() {
    loadJson().then((value) {
      setState(() {
        final jsonResponse = json.decode(value);
        moviedb = MovieDB.fromJson(jsonResponse);
      });
    });
  }

  Future<String> loadJson() async {
    String jsonString = await rootBundle.loadString('assets/data/movies.json');
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getText("Marvel Stories", 23.0),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        height: double.infinity,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: moviedb != null
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: moviedb.movies.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        var movie = moviedb.movies[index];
                        return Column(children: <Widget>[
                          gS(10.0, 0.0),
                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  top: 15.0, left: 5.0, right: 5.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 230.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(movie.imagepath),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:  Colors.grey.withOpacity(0.15),
                                        child: IconButton(
                                            icon: movie.isfav
                                                ? Icon(Icons.favorite,
                                                    color: Colors.red)
                                                : Icon(Icons.favorite_border),
                                            onPressed: () {}),
                                      ),
                                      title: getText(movie.title, 23.0),
                                      subtitle:
                                          getText(movie.description, 15.0),
                                    ),
                                  ),
                                ],
                              ))
                        ]);
                      })
                  : Container(),
            ),
            gS(15.0, 0.0)
          ],
        ),
      ),
    );
  }
}

class MovieDB {
  List<Movies> movies;
  MovieDB.fromJson(Map<String, dynamic> json) {
    if (json['movies'] != null) {
      movies = new List<Movies>();
      json['movies'].forEach((v) {
        movies.add(new Movies.fromJson(v));
      });
    }
  }
}

class Movies {
  String title;
  String imagepath;
  String description;
  bool isfav;

  Movies({this.title, this.imagepath, this.description, this.isfav});

  Movies.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imagepath = json['imagepath'];
    description = json['description'];
    isfav = json['isfav'];
  }
}
