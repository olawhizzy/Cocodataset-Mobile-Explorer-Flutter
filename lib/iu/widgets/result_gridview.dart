import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/explorer_controller.dart';
class ResultGridView extends StatelessWidget {
  const ResultGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExplorerController explore = Get.find();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: explore.resultImg.length < 1 ? Text('Select and submit, before display result') : GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: 8,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              //child: Text(resultImg[index]["flickr_url"]),
              decoration: BoxDecoration(
                  color: Colors.amber,
                  image: DecorationImage(image: NetworkImage(explore.resultImg[index]["coco_url"]), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15)),
            );
          }),
    );
  }
}
