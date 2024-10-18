import 'dart:io';

import 'package:check_plant/PlantIdentifyResult.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class Displaypicturescreen extends StatefulWidget {
  final String imagePath;
  Displaypicturescreen({super.key, required this.imagePath});

  @override
  State<Displaypicturescreen> createState() => _DisplaypicturescreenState();
}

class _DisplaypicturescreenState extends State<Displaypicturescreen> {
  File? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = File(widget.imagePath);
  }

  Future<void> indentifyPlant() async {
    if (_image == null) return;

    var uri = Uri.parse(
        'https://my-api.plantnet.org/v2/identify/all?api-key=2b10v5D6z5k5Wianu4J4RugTJ');
    var request = http.MultipartRequest('POST', uri);

    // Determine the mime type of the image
    String? mimeType = lookupMimeType(_image!.path);
    var mimeTypeData = mimeType?.split('/');

    // Add the image file as multipart
    request.files.add(
      await http.MultipartFile.fromPath(
        'images', // 'images' is the expected field name for Pl@ntNet API
        _image!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ),
    );

    // You can add more data to the request if needed, like organs (optional)
    request.fields['organs'] = 'leaf'; // Example: 'leaf', 'flower', etc.

    // Send the request
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print(responseData.body);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlantIdentifyResult(result: responseData.body),
          )); // Process the plant identification response
    } else {
      print('Failed to identify plant. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display picture"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(widget.imagePath)),
          TextButton(
              onPressed: () {
                indentifyPlant();
              },
              child: Text("Identify"))
        ],
      ),
    );
  }
}
