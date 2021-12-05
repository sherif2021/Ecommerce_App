import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final ImageModel image;
  final double width, height;

  const ImageWidget(
      {Key? key,
      required this.image,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.path != null && image.path!.isNotEmpty
        ? Image.file(
            File(image.path!),
            height: height,
            width: width,
            fit: BoxFit.fill,
          )
        : image.url != null && image.url!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: image.url!,
                fit: BoxFit.fill,
                placeholder: (context, url) => const SizedBox(
                    height: 10,
                    width: 10,
                    child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: height,
                width: width,
              )
            : SizedBox(
                width: width,
                height: height,
                child: const Text('No Picture'),
              );
  }
}
