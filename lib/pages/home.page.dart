import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provamaps/conexao.dart';
import 'package:provamaps/map.page.dart';
import 'package:provamaps/pages/addloc.dart';

Conn db = Conn();
var lista;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  listar() {
      db.getLatitudeLong().then((result) {
        setState(() {
          lista = result;
        });
      });
    }

     @override
      void initState() {
      super.initState();

      //db.deleteAll();
      listar();
    }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: SizedBox(
            width: 100,
            child: Image.asset("assets/app-logo.png"),
          ),
        ),
        actions: <Widget>[
          Container(
            width: 60,
            child: FlatButton(
              child: Icon(
                Icons.search,
                color: Color(0xFFBABABA),
              ),
              onPressed: () => {
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF2F3F6),
        child: ListView.builder(
            padding: EdgeInsets.only(top: 100, left: 30, right: 30),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(lista[index].latitude,
                        style: TextStyle(fontSize: 15))),
                        Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(lista[index].nome,
                        style: TextStyle(fontSize: 15))),
                        Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(lista[index].longitude,
                        style: TextStyle(fontSize: 15))),
                    RaisedButton(
                      child: Text("Abir Mapa"),
                      onPressed: () => Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => MapPage(lista[index].nome, lista[index].longitude))),)
                ],
                ),
              ],
            );
            },
          
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => addloc(),
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}


