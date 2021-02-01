import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:self_analysis/db/Database.dart';
import 'package:self_analysis/models/MessageModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }

}


class _MyAppState extends State<MyApp> {
  //final List<String> _items = new List();// ["1","2","3"];
  String _value;

  @override
  void initState() {
    _value = "Сообщение";
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Само-анализ",
      home: Scaffold(
        backgroundColor: Color(0xffb0c4de), // 0xffbbccdd
        appBar: AppBar(
          title: Text("Само-анализ"),
          centerTitle: true,
        ),
        body: Column (
          children: [
            Expanded(
              // Для того чтобы использовать данные из базы данных используем FutureBuilder
              child : FutureBuilder<List<Message>>(
                future: DBProvider.db.getAllMessages(),// Получаем все уже созданные сообщения
                // Как только получаем данные списка сообщений (снимок) строим список
                builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,//Получаем количество полученных в снимке сообщений
                        itemBuilder: (BuildContext context, int index) {
                        Message item = snapshot.data[index]; //Для каждого элемента снимка строим карточку
                      return Card(
                          margin: EdgeInsets.only(left:16,right: 16,top:5,bottom: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child:
                          ListTile(
                            leading : Icon(Icons.person),
                            title: Text(item.content.toString()),//Переводим поле content в строку
                          )
                      );
                    },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },

        ),

            ),
            Divider(
              thickness: 3
            ),
            Container(
              width: 370,
              height : 70,
              margin: EdgeInsets.only(left: 20, right: 90, bottom: 5),
              child: TextField(
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    //alignLabelWithHint: true,
                    hintStyle: TextStyle(fontSize: 20.0),
                    hintText: "Сообщение"
                ),
                onChanged: (String str) {
                  setState(() {
                    _value = str;
                  });
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //setState(() {
            //  _items.add(_value);
            //});
            //print(_items);
            // Составляем сообщение по введенному тексту
            Message thismessage = Message(content: _value);
            // Добавляем новое сообщение в базу данных
            await DBProvider.db.newMessage(thismessage);
            setState(() {});
          },
          child: Icon(Icons.message),
        ),
      ),
    );
  }
}