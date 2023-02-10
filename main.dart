// ignore_for_file: iterable_contains_unrelated_type, prefer_const_constructors, implementation_imports

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/src/plaform/open_file.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  List<String> fileName = ["PNG", "JPG", "JPEG", "PDF", "DOC", "DOCX"];
  List<String> fileUrl = [
    "https://w7.pngwing.com/pngs/895/199/png-transparent-spider-man-heroes-download-with-transparent-background-free-thumbnail.png",
    "https://www.shutterstock.com/image-photo/surreal-image-african-elephant-wearing-260nw-1365289022.jpg",
    "https://jpeg.org/images/jpeg-home.jpg",
    "https://monitoring.7mantra.in/storage/certificate/birth/2_dart.pdf",
    "https://docs.google.com/document/d/1Yf7F-pGViYv48kdlGiVeFxDOEhWC3kq1/edit",
    "https://docs.google.com/document/d/1Yf7F-pGViYv48kdlGiVeFxDOEhWC3kq1/edit",
  ];
  List<int> fileMatch = [];
  String url = "";
  String remotePDFpath = "";
  String filePath = "";
  var _openResult = 'Unknown';
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black38,
            title: Text("Open Any File From URL"),
          ),
          body: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black38),
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: fileName.length,
                  itemBuilder: (BuildContext context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${fileName[index]} File"),
                        SizedBox(
                            width: 50,
                            child: Text(
                              fileUrl[index],
                              overflow: TextOverflow.ellipsis,
                            )),
                        TextButton.icon(
                            onPressed: () {
                              createFileOfUrl(fileUrl[index]).then((f) {
                                setState(() {
                                  remotePDFpath = f.path;
                                  openFile(remotePDFpath);
                                  fileMatch.add(index);
                                });
                              });
                            },
                            icon: Icon(
                                color: fileMatch.contains(index)
                                    ? Colors.black
                                    : Colors.red,
                                fileMatch.contains(index)
                                    ? Icons.lock_open_rounded
                                    : Icons.file_open_outlined),
                            label: fileMatch.contains(index)
                                ? Text(
                                    "OPENED",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text("OPEN File",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ))),
                      ],
                    );
                  }))),
    );
  }

  Future<void> openFile(path) async {
    filePath = path;

    final _result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=$_result  message=$_openResult";
    });
  }

  Future<File> createFileOfUrl(String Url) async {
    Completer<File> completer = Completer();

    try {
      final url = Url;

      final filename = url.substring(url.lastIndexOf("/") + 1);

      var request = await HttpClient().getUrl(Uri.parse(url));

      var response = await request.close();

      var bytes = await consolidateHttpClientResponseBytes(response);

      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);

      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
