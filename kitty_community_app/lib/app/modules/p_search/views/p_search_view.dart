import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/p_search_controller.dart';

class PSearchView extends GetView<PSearchController> {
  const PSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PSearchView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PSearchView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
