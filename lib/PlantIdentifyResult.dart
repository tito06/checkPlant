import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PlantIdentifyResult extends StatefulWidget {
  final String result;
  PlantIdentifyResult({super.key, required this.result});

  @override
  State<PlantIdentifyResult> createState() => _PlantIdentifyResultState();
}

class _PlantIdentifyResultState extends State<PlantIdentifyResult> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> jsonResponse = json.decode(widget.result);

    List<dynamic> speciesList = jsonResponse['results'];

    String speciesInfo = '';

    for (var species in speciesList) {
      String scientificName = species['scientificName'] ?? 'N/A';
      String commonName =
          species['commonNames'] != null && species['commonNames'].isNotEmpty
              ? species['commonNames']
                  [0] // Assuming the first common name is desired
              : 'N/A';

      speciesInfo += 'Scientific Name: $scientificName\n';
      speciesInfo += 'Common Name: $commonName\n\n';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Identification Result'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: speciesList.length,
        itemBuilder: (context, index) {
          var species = speciesList[index]['species'];
          String scientificName = species['scientificName'] ?? 'N/A';
          String scientificNameWithoutAuthor =
              species['scientificNameWithoutAuthor'] ?? 'N/A';
          String commonName = species['commonNames'] != null &&
                  species['commonNames'].isNotEmpty
              ? species['commonNames'][0] // Use the first common name
              : 'N/A';
          String family =
              species['family']['scientificNameWithoutAuthor'] ?? 'N/A';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scientific Name: $scientificName',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'Scientific Name (Without Author): $scientificNameWithoutAuthor'),
                  Text('Common Name: $commonName'),
                  Text('Family: $family'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
