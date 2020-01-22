import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FinishPage extends StatefulWidget {
  final int corrects;
  final int total;
  final String path;
  Function refresher;

  FinishPage(this.corrects, this.total, this.path, this.refresher);

  @override
  _FinishPageState createState() =>
      _FinishPageState(corrects, total, path, refresher);
}

class _FinishPageState extends State<FinishPage> {
  String rating;
  final int corrects;
  final int total;
  final String path;
  Function refresher;

  List picDescription = [];
  File pic;
  List newJsonList;

  _FinishPageState(this.corrects, this.total, this.path, this.refresher);

  var timeStamp = DateTime.now().millisecondsSinceEpoch;
  TextEditingController textController = TextEditingController();

  Future<String> createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "Enter some descriptions. \nYou may submit multiple fields by submitting multiple times."),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(textController.text.toString());
                },
                child: Text("Submit"),
              )
            ],
          );
        });
  }

  pickImage() async {
    var rawPic = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pic = rawPic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 500,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.indigo,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    pic == null
                        ? Text("No image selected!")
                        : ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 300,
                            ),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                child: Image.file(pic)),
                          ),
                    Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            // Add image

                            pickImage();
                          },
                          child: Text("Select Image"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            createAlertDialog(context).then((onValue) {
                              // Add descriptions

                              setState(() {
                                if (onValue != null) {
                                  picDescription.add(onValue);
                                  print(picDescription);
                                }
                              });
                            });
                          },
                          child: Text("Add A Description"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            // Upload image and descriptions

                            setState(() {
                              String newImgName =
                                  "$path/customImage-$timeStamp.jpg";
                              pic.copy(newImgName);
                              newJsonList = [
                                {
                                  "img": newImgName,
                                  "name": picDescription
                                }
                              ];
                              refresher(newJsonList);
                            });
                          },
                          child: Text("Upload!"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "Your got ${widget.corrects} out of ${widget.total} corrects!\n"
                "You may either add some new cards, or retry with existing flashcards.\n",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
