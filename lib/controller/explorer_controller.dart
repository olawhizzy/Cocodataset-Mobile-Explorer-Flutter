import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ExplorerController extends GetxController{
  List superCats = [];
  List cats = [];
  List resultImg = [];
  bool isLoading = false;

  void submit() async {
    isLoading = true;
    var client = http.Client();
    try {
      Map<String,String> headers = {
        "content-type" : "application/json; charset=UTF-8",
        "accept" : "application/json",
        //'Charset': 'utf-8',

      };
      var responseSupercat = await client.post(
        Uri.parse('https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery'),
        headers: headers,
        body: jsonEncode(
            {'category_ids': cats, 'querytype': 'getImagesByCats'}),
      );
      var decodedSuperCatResponse = jsonDecode(responseSupercat.body);
      print(decodedSuperCatResponse);
      var response = await client.post(
        Uri.parse('https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery'),
        headers: headers,
        body: jsonEncode(
            {'image_ids': decodedSuperCatResponse, 'querytype': 'getImages'}),
      );
      var decodedResponse = jsonDecode(response.body);

      print(decodedResponse);
      resultImg = decodedResponse;
      isLoading = false;

    } finally {
      isLoading = false;
      client.close();
    }
  }
}