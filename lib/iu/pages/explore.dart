import 'package:coco_mobile_explorer/iu/widgets/result_gridview.dart';
import 'package:coco_mobile_explorer/iu/widgets/submit_button.dart';
import 'package:coco_mobile_explorer/iu/widgets/super_category_dropdown.dart';
import 'package:coco_mobile_explorer/models/categories.dart';
import 'package:coco_mobile_explorer/models/supercates_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../controller/explorer_controller.dart';


class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExplorerController explore = Get.put(ExplorerController());
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            SuperCategoryDropDown(),
            SizedBox(height: 30,),
            SubmitButton(),
            SizedBox(height: 30,),
            explore.isLoading == true ? Text('Please wait, we are fecthing the data for you...') : Text('tes'),
            ResultGridView(),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
