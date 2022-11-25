import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:api_rest_ensallos/models/Gif.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Obtenido los datos de  la APi -------------------------------------------//
  late Future<dynamic> _listadoGifs;

  dynamic urlgif =
      'https://api.giphy.com/v1/gifs/trending?api_key=fVdEjYQzUoT1iwTQurPGtrIoZaOtRi62&limit=20&rating=g';

  Future<dynamic> _getGifs() async {
    final response = await http.get(Uri.parse(urlgif));

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData['data']) {
        gifs.add(Gif(
          name: item['title'],
          url: item['images']['downsized']['url'],
        ));
      }

      return gifs;
    } else {
      print('Falló la conección');
    }
  }

  // ejecuntando la peticon al inicio ----------------------------------//
  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  // fin los datos de  la APi -------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Api Rest',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('A P I R E S T'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _listadoGifs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: _listGifs(snapshot.data),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error');
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  List<Widget> _listGifs(List<Gif> data) {
    List<Widget> gifs = [];

    for (var gif in data) {
      gifs.add(Card(
          child: Column(
        children: [
          Expanded(child: Image.network(gif.url, fit: BoxFit.fill,)),
        ],
      )));
    }

    return gifs;
  }
}
