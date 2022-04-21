import 'dart:convert';

import 'package:coco_mobile_explorer/iu/pages/explore.dart';
import 'package:coco_mobile_explorer/iu/widgets/result_gridview.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'models/categories.dart';
import 'models/supercates_model.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Coco Explorer',), // Note all functional codes are on this page
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List superCats = [];
  List cats = [];
  List resultImg = [];
  List resultCap = [];
  bool isLoading = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    isLoading;
  }

  // for the search function
  void _searchResult() async {
    setState(() {
      isLoading = true;
    });
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
      var responseCaption = await client.post(
        Uri.parse('https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery'),
        headers: headers,
        body: jsonEncode(
            {'image_ids': decodedSuperCatResponse, 'querytype': 'getCaptions'}),
      );
      var decodedResponsecaption = jsonDecode(responseCaption.body);

      print(decodedResponse);
      setState(() {
        resultImg = decodedResponse;
        resultCap = decodedResponsecaption;
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownSearch<SuperCats>.multiSelection(
            mode: Mode.DIALOG,
            showSearchBox: true,
            //showSelectedItems: true,
            items: categoriesArray,
            itemAsString: (SuperCats? cats) => cats!.name,
            dropdownSearchDecoration: InputDecoration(
              labelText: "Data set label",
              //hintText: "Select ,
            ),
            onChanged: (List<SuperCats> value){
              print(value.map((e) => e.id).toList());
              setState(() {
                cats = value.map((e) => e.id).toList();
              });
            },
            //selectedItems: ["people"],
          ),
          SizedBox(height: 30,),
          isLoading == true ? Text('Please wait...') : Padding(
            padding: const EdgeInsets.all(8.0),
            child: resultImg.length < 1 ? Text('Select and submit, before display result') : Container(
              height: 520,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
                  itemCount: 16,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: (){
                        Get.defaultDialog(
                            title: "The Captions",
                            middleText: resultCap[index]['caption'],
                            backgroundColor: Colors.teal,
                            titleStyle: TextStyle(color: Colors.white),
                            middleTextStyle: TextStyle(color: Colors.white),
                            radius: 30
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        //child: Text(resultImg[index]["flickr_url"]),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            image: DecorationImage(image: NetworkImage(resultImg[index]["coco_url"]), fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchResult,
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
