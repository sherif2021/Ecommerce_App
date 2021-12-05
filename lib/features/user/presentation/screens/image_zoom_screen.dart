import 'dart:io';
import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/admin/presentation/logic/items_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageZoomScreen extends StatelessWidget {
  const ImageZoomScreen({Key? key, required this.image, this.controller})
      : super(key: key);

  final ImageModel image;

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(
          color: Colors.white,
        ),
        actions: [
          if (controller is ItemsController)
            IconButton(
                onPressed: () {
                  if (controller is ItemsController) {
                    controller.item.value!.pics.remove(image);
                    controller.item.value!.colors.remove(image);
                    controller.item.refresh();
                    if (image.path != null) File(image.path!).delete();
                    Get.back();
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ))
        ],
      ),
      body: InteractiveViewer(
        child: ImageWidget(
          image: image,
          width: Get.width,
          height: Get.height,
        ),
      ),
    );
  }
}
