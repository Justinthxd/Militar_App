import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarea_8/pages/class_record.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Record record = Record();

  List<int> list = [];
  List<DateTime> times = [];
  List<String> titles = [];
  List<String> descriptions = [];
  List<dynamic> files = [];

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  PageController controllerPage = PageController();

  bool isRecording = false;
  bool isPhoto = false;

  int count = 0;

  File? imageFile = null;

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              child: Image.network(
                'https://i.pinimg.com/236x/45/2e/3d/452e3d4b9ff8a33170a336461ba0e523.jpg',
                fit: BoxFit.cover,
                color: Color.fromARGB(167, 0, 0, 0),
                colorBlendMode: BlendMode.color,
              ),
            ),
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.0,
                    color: Color.fromARGB(225, 25, 25, 25),
                    offset: Offset(0.0, 0.0),
                  ),
                ],
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(),
            ),
            PageView(
              controller: controllerPage,
              children: [
                Column(
                  children: [
                    SizedBox(height: 50),
                    Row(
                      children: [
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 25,
                          ),
                          onPressed: () {
                            for (int i = 0; i < list.length; i++) {
                              record.delete(i);
                            }
                            list.clear();
                            descriptions.clear();
                            times.clear();
                            files.clear();
                            titles.clear();
                            imageFile = null;
                            count = 0;
                            setState(() {});
                          },
                        ),
                        Spacer(),
                        Text(
                          "Bitacoras",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 30,
                          ),
                          onPressed: () {
                            controllerPage.animateToPage(
                              1,
                              duration: Duration(seconds: 1),
                              curve: Curves.linearToEaseOut,
                            );
                          },
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    list.length == 0
                        ? Column(
                            children: [
                              SizedBox(height: 250),
                              Text(
                                "Add new items",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: Container(
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: list.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(183, 29, 29, 29),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5.0,
                                          color: Colors.black38,
                                          offset: Offset(0.0, 0.0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              titles.isNotEmpty
                                                  ? titles[i].isEmpty
                                                      ? "Untitled"
                                                      : titles[i]
                                                  : "",
                                              style: TextStyle(
                                                fontSize: 30,
                                              ),
                                            ),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.play_arrow_rounded,
                                                size: 40,
                                              ),
                                              onPressed: () {
                                                record.play(i);
                                              },
                                            ),
                                          ],
                                        ),
                                        Text(
                                          times[i].toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white54),
                                        ),
                                        SizedBox(height: 10),
                                        descriptions.isNotEmpty
                                            ? descriptions[i].isEmpty
                                                ? Text("")
                                                : Text(
                                                    "Note: " + descriptions[i],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white54,
                                                    ),
                                                  )
                                            : Container(),
                                        SizedBox(height: 7),
                                        Row(
                                          children: [
                                            files[i] != 'null'
                                                ? Container(
                                                    width: size.width - 60,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 130,
                                                          width: 130,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Image.file(
                                                            files[i],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Container(
                                                            height: 130,
                                                            width: 130,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black12,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Text(
                              "Historial",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 34, 66, 82),
                              ),
                              child: Text("Cancel"),
                              onPressed: () {
                                controllerDescription.clear();
                                controllerTitle.clear();
                                imageFile = null;
                                setState(() {});
                              },
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 51, 134, 54),
                              ),
                              child: Text("Add"),
                              onPressed: () {
                                list.add(count);
                                count++;
                                times.add(DateTime.now());
                                titles.add(controllerTitle.text);
                                descriptions.add(controllerDescription.text);
                                if (imageFile != null) {
                                  files.add(imageFile!);
                                } else {
                                  files.add("null");
                                }
                                imageFile = null;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: controllerTitle,
                            decoration: InputDecoration(
                              hintText: 'Title',
                              hintStyle: TextStyle(
                                color: Colors.white60,
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 35, 35, 35),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 49, 49, 49)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: controllerDescription,
                            maxLines: 9,
                            decoration: InputDecoration(
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                color: Colors.white60,
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 35, 35, 35),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(255, 49, 49, 49)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 35, 35, 35),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                "Audio",
                                style: TextStyle(
                                  color: isRecording
                                      ? Colors.greenAccent
                                      : Colors.white60,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              !isRecording
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.mic_rounded,
                                        size: 27,
                                      ),
                                      onPressed: () {
                                        record.start(count);
                                        isRecording = true;
                                        setState(() {});
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.square_rounded,
                                        color: Colors.red,
                                        size: 27,
                                      ),
                                      onPressed: () {
                                        isRecording = false;
                                        record.stop();
                                        setState(() {});
                                      },
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 300,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 35, 35, 35),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: imageFile != null
                              ? Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _getFromCamera();
                                        },
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          size: 50,
                                          color: Colors.white24,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _getFromGallery();
                                        },
                                        child: Icon(
                                          Icons.filter,
                                          size: 50,
                                          color: Colors.white24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
