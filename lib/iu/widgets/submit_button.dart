import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controller/explorer_controller.dart';
class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExplorerController explore = Get.put(ExplorerController());
    return ElevatedButton(
      onPressed: () async {
        explore.submit();
      },
      child: Text('Submit'),
    );
  }
}
