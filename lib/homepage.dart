import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class homepage extends StatelessWidget {
  homepage({Key? key}) : super(key: key);
  final TextEditingController textcontrol = TextEditingController();
  String info = "";
  int index = 0;

  Color addColor() {
    if (index % 2 == 0) {
      return Color.fromRGBO(237, 238, 238, 0.5);
    } else
      return Color.fromRGBO(237, 238, 238, 0.5);
  }

  void addTask() {
    if (textcontrol.text == "") {
      return;
    } else {
      FirebaseFirestore.instance
          .collection("todos")
          .add({"title": textcontrol.text});
    }
  }

  onDelete(String id) {
    FirebaseFirestore.instance.collection("todos").doc(id).delete();
  }

  Widget buildbody(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 25,
            ),
            Expanded(
                child: TextField(
              controller: textcontrol,
            )),
            SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  info = textcontrol.toString();
                  print(textcontrol.text);
                  addTask();
                  index++;
                },
                icon: Icon(
                  Icons.add,
                  size: 40,
                )),
            SizedBox(
              width: 19,
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("todos").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else
                return Expanded(
                    child: ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.delete_forever_sharp,
                          size: 40,
                        ),
                      ),
                      key: Key(document.id),
                      onDismissed: (direction) {
                        onDelete(document.id);
                      },
                      child: Container(
                        color: addColor(),
                        child: ListTile(
                          title: Text(
                            document['title'],
                            style: GoogleFonts.redHatDisplay(
                                fontSize: 25, color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ));
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Tasks',
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 30),
        ),
      ),
      body: buildbody(context),
    );
  }
}
