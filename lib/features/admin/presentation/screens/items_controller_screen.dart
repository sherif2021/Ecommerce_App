import 'dart:io';
import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/admin/presentation/logic/items_controller.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/data/model/item_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/item_widget.dart';
import 'package:get/get.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';


class ItemsControllerScreen extends StatelessWidget {
  ItemsControllerScreen({Key? key})
      : super(key: key);

  final _homeController = Get.put(HomeController());

  final _controller = Get.put(ItemsController());

  final imagePicker = ImagePicker();

  final _allSizes = [
    'XXS',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    '3XL',
    '4XL',
    '5XL',
    '6XL',
    '7XL'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_controller.isSearching.isTrue) {
          _controller.isSearching.value = false;
          return Future.value(false);
        }
        Get.delete<ItemsController>();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            leading: const BackButton(
              color: Colors.white,
            ),
            title: Text(
              'Items Controller',
              style: Get.textTheme.headline6!
                  .copyWith(color: Colors.white, fontSize: 16),
            ),
            actions: [
              Obx(() => _controller.isSearching.value
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: _controller.search,
                      ),
                    ))
                  : IconButton(
                      onPressed: () {
                        _controller.isSearching.value = true;
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      )))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _controller.item.value = ItemModel(
                  title: '',
                  pics: [],
                  colors: [],
                  sizes: [],
                  price: 0,
                  discount: 0,
                  rating: 5,
                  catId: _controller.selectedCategory.value != 'all'
                      ? _controller.selectedCategory.value!
                      : _homeController.categories.first.id!,
                  inStock: true);
              _showAddOrEditBottomSheet(context, false);
            },
            child: const Icon(Icons.add),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => _controller.isSearching.value
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                            isExpanded: true,
                            items: [
                              CategoryModel(
                                  id: 'all',
                                  index: 0,
                                  name: 'All',
                                  pic: ImageModel(),
                                  type: 1),
                              ..._homeController.categories
                            ]
                                .map((e) => DropdownMenuItem(
                                    child: Text(e.name), value: e.id))
                                .toList(),
                            value: _controller.selectedCategory.value ?? 'all',
                            onChanged: (v) {
                              _controller.selectedCategory.value = v as String;
                              _controller.getItems();
                            },
                          ),
                        ),
                ),
                Obx(
                  () => GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _controller.isSearching.value
                          ? _controller.searchingItems.length
                          : _controller.items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 300,
                              mainAxisSpacing: 5,
                              childAspectRatio: 5),
                      itemBuilder: (_, index) {
                        final item = _controller.isSearching.value
                            ? _controller.searchingItems[index]
                            : _controller.items[index];

                        return ItemWidget(
                          item: item,
                          onClick: () {
                            Get.bottomSheet(Container(
                              color: Get.theme.scaffoldBackgroundColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      Get.back();
                                      _controller.item.value = item;
                                      _showAddOrEditBottomSheet(context, true);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.edit_outlined),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Get.back();
                                      Get.defaultDialog(
                                          title: 'Confirm!',
                                          middleText:
                                              'Are you sure to delete this item \n(${item.title})',
                                          textConfirm: 'Yes',
                                          onConfirm: () async {
                                            Get.back();
                                            _removeItem(index);
                                          },
                                          textCancel: 'No');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                        );
                      }),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          )),
    );
  }

  void _showAddOrEditBottomSheet(BuildContext context, bool isEditing) {
    final item = _controller.item.value!;

    Get.bottomSheet(
        FractionallySizedBox(
          heightFactor: 0.9,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: item.title,
                    onChanged: (v) => item.title = v,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              item.price > 0 ? item.price.toString() : '',
                          onChanged: (v) =>
                              item.price = double.tryParse(v) ?? 0,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Price',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              item.discount > 0 ? item.discount.toString() : '',
                          onChanged: (v) =>
                              item.discount = double.tryParse(v) ?? 0,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Discount',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category : ',
                        style: Get.textTheme.headline6,
                      ),
                      Obx(
                        () => DropdownButton(
                          items: _homeController.categories
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.name),
                                    value: e.id,
                                  ))
                              .toList(),
                          value: _controller.item.value!.catId,
                          onChanged: (String? value) {
                            _controller.item.value!.catId = value!;
                            _controller.item.refresh();
                          },
                          //onChanged: (index){},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pictures : ',
                        style: Get.textTheme.headline6,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () => _openImagePicker(
                              fromCamera: true, addToPictures: true),
                          icon: const Icon(Icons.camera_alt_outlined)),
                      IconButton(
                          onPressed: () => _openImagePicker(
                              fromCamera: false, addToPictures: true),
                          icon: const Icon(Icons.image_outlined)),
                      IconButton(
                          onPressed: () =>
                              _openAddImageLinkDialog(addToPictures: true),
                          icon: const Icon(Icons.insert_link)),
                    ],
                  ),
                  Obx(
                    () => Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: _controller.item.value!.pics
                          .map((e) => GestureDetector(
                                onTap: () =>
                                    Get.toNamed(imageZoomScreen, arguments: [e, _controller]),
                                onLongPress: () {
                                  _controller.item.value!.pics.remove(e);
                                  _controller.item.refresh();
                                  if (e.path != null) File(e.path!).delete();
                                },
                                child: ImageWidget(
                                    image: e, width: 100, height: 100),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'In Stock : ',
                        style: Get.textTheme.headline6,
                      ),
                      Obx(() => Switch(
                          value: _controller.item.value!.inStock,
                          onChanged: (v) {
                            _controller.item.value!.inStock = v;
                            _controller.item.refresh();
                          })),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Colors : ',
                        style: Get.textTheme.headline6,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () => _openImagePicker(
                              fromCamera: true, addToPictures: false),
                          icon: const Icon(Icons.camera_alt_outlined)),
                      IconButton(
                          onPressed: () => _openImagePicker(
                              fromCamera: false, addToPictures: false),
                          icon: const Icon(Icons.image_outlined)),
                      IconButton(
                          onPressed: () =>
                              _openAddImageLinkDialog(addToPictures: false),
                          icon: const Icon(Icons.insert_link)),
                    ],
                  ),
                  Obx(
                    () => Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: _controller.item.value!.colors
                          .map((e) => GestureDetector(
                                onTap: () =>
                                    Get.toNamed(imageZoomScreen, arguments: [e, _controller]),
                                onLongPress: () {
                                  _controller.item.value!.colors.remove(e);
                                  _controller.item.refresh();
                                  if (e.path != null) File(e.path!).delete();
                                },
                                child: ImageWidget(
                                    image: e, width: 100, height: 100),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () => Get.dialog(AlertDialog(
                              content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                runSpacing: 5,
                                spacing: 5,
                                children: _allSizes
                                    .map((e) => Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              if (_controller.item.value!.sizes
                                                  .contains(e)) {
                                                item.sizes.remove(e);
                                              } else {
                                                item.sizes.add(e);
                                              }
                                              _controller.item.refresh();
                                            },
                                            child: SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: CircleAvatar(
                                                  child: Text(e),
                                                  backgroundColor: _controller
                                                          .item.value!.sizes
                                                          .contains(e)
                                                      ? primaryColor
                                                      : Colors.grey,
                                                )),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MaterialButton(
                                    color: buttonColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      item.sizes = _allSizes;
                                      _controller.item.refresh();
                                      Get.back();
                                    },
                                    child: const Text('All'),
                                  ),
                                  MaterialButton(
                                    color: primaryColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      item.sizes.clear();
                                      _controller.item.refresh();
                                      Get.back();
                                    },
                                    child: const Text('Clear All'),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              MaterialButton(
                                color: primaryColor,
                                textColor: Colors.white,
                                onPressed: Get.back,
                                child: const Text('CLose'),
                              )
                            ],
                          ))),
                      icon: const Icon(Icons.format_size_outlined)),
                  Obx(
                    () => Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: _controller.item.value!.sizes
                          .map((e) => GestureDetector(
                                onTap: () {
                                  item.sizes.remove(e);
                                  _controller.item.refresh();
                                },
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircleAvatar(
                                        child: Text(e),
                                        backgroundColor:
                                            primaryColor.withOpacity(.7),
                                      )),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Obx(() => MaterialButton(
                          textColor: Colors.white,
                          onPressed: _controller.isLoading.value
                              ? null
                              : () => _handleAddOrEditItem(isEditing),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(isEditing ? 'Edit' : 'Add'),
                          ),
                          color: primaryColor,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular((10))),
        ));
  }

  void _openImagePicker(
      {required bool fromCamera, required bool addToPictures}) async {
    if (fromCamera) {
      final image = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 75);

      if (image != null) {
        if (addToPictures) {
          _controller.item.value!.pics.add(ImageModel(path: image.path));
        } else {
          _controller.item.value!.colors.add(ImageModel(path: image.path));
        }
        _controller.item.refresh();
      }
    } else {
      final images = await imagePicker.pickMultiImage(
        imageQuality: 75,
      );
      if (images != null) {
        if (addToPictures) {
          _controller.item.value!.pics
              .addAll(images.map((e) => ImageModel(path: e.path)).toList());
        } else {
          _controller.item.value!.colors
              .addAll(images.map((e) => ImageModel(path: e.path)).toList());
        }
        _controller.item.refresh();
      }
    }
  }

  void _openAddImageLinkDialog({required bool addToPictures}) {
    String? link;
    Get.defaultDialog(
        title: 'Add Picture Link',
        content: TextField(
          onChanged: (v) => link = v,
          autofocus: false,
        ),
        textCancel: 'Cancel',
        textConfirm: 'Add',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          if (link != null && link!.startsWith('http')) {
            if (addToPictures) {
              _controller.item.value!.pics.add(ImageModel(url: link));
            } else {
              _controller.item.value!.colors.add(ImageModel(url: link));
            }
            _controller.item.refresh();
          }
        });
  }

  void _handleAddOrEditItem(bool isEditing) async {
    final item = _controller.item.value!;

    if (item.title.isEmpty) {
      _renderErrorDialog('can\'t ${isEditing ? 'Edit' : 'add'} without Title.');
    } else if (item.price == 0) {
      _renderErrorDialog('can\'t ${isEditing ? 'Edit' : 'add'} without Price.');
    } else if (item.catId.isEmpty) {
      _renderErrorDialog(
          'can\'t ${isEditing ? 'Edit' : 'add'} without Category.');
    } else if (_controller.item.value!.pics.isEmpty) {
      _renderErrorDialog(
          'can\'t ${isEditing ? 'Edit' : 'add'} without Pictures.');
    } else if (item.discount >= item.price) {
      _renderErrorDialog('discount must be less than price.');
    } else {
      
      _controller.isLoading.value = true;

      final imagesUploadResult = await _controller.uploadImages();

      if (imagesUploadResult) {
        final result = await _controller.addOrEditItem();

        if (result) {
          Get.back();

          if (isEditing) {
            _controller.items.refresh();
          } else {
            _controller.items.add(_controller.item.value!);
            final category = _homeController.categories.firstWhereOrNull((cat) => cat.id == item.catId && cat.type == 2);
            if (category != null){
              category.items ??= [];
              category.items?.add(item);
            }
          }
          _homeController.categories.refresh();
        }
        Get.defaultDialog(
            title: result ? 'Success' : 'Error!',
            middleText: result
                ? 'Item has been ${isEditing ? 'Edited' : 'added'}.'
                : 'Failed to ${isEditing ? 'Edit' : 'add'} Item, try again.',
            textCancel: 'Ok');
      } else {
        Get.defaultDialog(
            title: 'Error!',
            middleText: 'Failed to upload pictures.',
            textCancel: 'Ok');
      }
      _controller.isLoading.value = false;
    }
  }

  void _removeItem(int index) async {
    final item = _controller.isSearching.value
        ? _controller.searchingItems[index]
        : _controller.items[index];

    final result = await _controller.removeItem(item);
    if (result) {
      _controller.items.removeWhere((e) => e.id == item.id);
      _controller.searchingItems.removeWhere((e) => e.id == item.id);
      _homeController.categories.refresh();
      final cat = _homeController.categories.firstWhereOrNull((e) => e.id == item.catId);
      if (cat != null && cat.items != null){
        cat.items?.removeWhere((e) => e.id == item.id);
      }
    }
  }

  void _renderErrorDialog(String message) {
    Get.defaultDialog(title: 'Error!', middleText: message, textCancel: 'OK');
  }
}
