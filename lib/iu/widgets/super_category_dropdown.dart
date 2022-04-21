import 'package:coco_mobile_explorer/controller/explorer_controller.dart';
import 'package:coco_mobile_explorer/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../../models/supercates_model.dart';
class SuperCategoryDropDown extends StatelessWidget {
  const SuperCategoryDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExplorerController explore = Get.put(ExplorerController());
    return DropdownSearch<SuperCats>.multiSelection(
      mode: Mode.DIALOG,
      showSearchBox: true,
      //showSelectedItems: true,
      items: categoriesArray,
      itemAsString: (SuperCats? cats) => cats!.name,
      dropdownSearchDecoration: InputDecoration(
        labelText: "Menu mode",
        hintText: "country in menu mode",
      ),
      onChanged: (List<SuperCats> value){
        explore.cats = value.map((e) => e.id).toList();
      },
      //selectedItems: ["people"],
    );
  }
}
