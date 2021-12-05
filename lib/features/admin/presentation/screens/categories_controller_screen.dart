import 'package:ecommerce/features/user/data/model/image_model.dart';
import 'package:ecommerce/features/admin/presentation/logic/categories_controller.dart';
import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/category_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CategoriesControllerScreen extends StatelessWidget {
  CategoriesControllerScreen({Key? key}) : super(key: key);

  final _controller = Get.put(CategoriesController());
  final _homeController = Get.put(HomeController());

  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (_controller.currentCategories.isEmpty) fillCurrentCategories();

    return WillPopScope(
      onWillPop: () {
        Get.delete<CategoriesController>();
        if (_controller.isUpdatingIndexes.value) reOrderCategories();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: Text(
            'Categories Controller',
            style: Get.textTheme.headline6!
                .copyWith(color: Colors.white, fontSize: 16),
          ),
          actions: [
            Obx(() => _controller.isUpdatingIndexes.value
                ? IconButton(
                    onPressed: updateIndexes,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ))
                : const SizedBox())
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _controller.category.value = CategoryModel(
                  pic: ImageModel(),
                  name: '',
                  index: 0,
                  type: _controller.selectedCategoryType.value);
              _showAddOrEditBottomSheet(context, true);
            },
            child: const Icon(Icons.add)),
        body: SizedBox.expand(
          child: Obx(
            () => Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: DropdownButton(
                    isExpanded: true,
                    items: categoriesType
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    value:
                        categoriesType[_controller.selectedCategoryType.value],
                    onChanged: (v) {
                      if (_controller.isUpdatingIndexes.value) {
                        _controller.isUpdatingIndexes.value = false;
                        reOrderCategories();
                      }
                      _controller.selectedCategoryType.value =
                          categoriesType.indexOf(v as String);
                      fillCurrentCategories();
                    },
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    onReorder: (oldIndex, newIndex) {
                      final category = _controller.currentCategories[oldIndex];
                      _controller.currentCategories.remove(category);
                      _controller.currentCategories.insert(
                          newIndex > _controller.currentCategories.length
                              ? newIndex - 1
                              : newIndex,
                          category);
                      if (_controller.isUpdatingIndexes.isFalse) {
                        _controller.isUpdatingIndexes.value = true;
                      }
                    },
                    shrinkWrap: true,
                    itemCount: _controller.currentCategories.length,
                    itemBuilder: (_, index) {
                      final category = _controller.currentCategories[index];

                      return CategoryWidget(
                        category: category,
                        key: ValueKey(category),
                        onClick: () {
                          Get.bottomSheet(Container(
                            color: Get.theme.scaffoldBackgroundColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Get.back();
                                    _controller.category.value = category;
                                    _showAddOrEditBottomSheet(context, false);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            'Are you sure to delete this category \n(${category.name})',
                                        textConfirm: 'Yes',
                                        onConfirm: () async {
                                          Get.back();
                                          _removeCategory(index);
                                        },
                                        textCancel: 'No');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddOrEditBottomSheet(BuildContext context, bool isAdding) {
    final category = _controller.category.value!;

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
                      initialValue: category.name,
                      onChanged: (v) => category.name = v,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => _openImagePicker(true),
                            icon: const Icon(Icons.camera_alt_outlined)),
                        IconButton(
                            onPressed: () => _openImagePicker(false),
                            icon: const Icon(Icons.image_outlined)),
                        IconButton(
                            onPressed: _openAddImageLinkDialog,
                            icon: const Icon(Icons.insert_link)),
                      ],
                    ),
                    Obx(
                      () => ImageWidget(
                          image: _controller.category.value!.pic,
                          width: Get.width,
                          height: 300),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Type : '),
                        Obx(() => DropdownButton(
                            items: categoriesType
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            value: categoriesType[
                                _controller.category.value!.type],
                            onChanged: (v) {
                              _controller.category.value!.type =
                                  categoriesType.indexOf(v as String);
                              _controller.category.refresh();
                            })),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: Obx(() => MaterialButton(
                            textColor: Colors.white,
                            onPressed: _controller.isLoading.value
                                ? null
                                : () => _handleAddOrEditItem(isAdding),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(isAdding ? 'Add' : 'Edit'),
                            ),
                            color: primaryColor,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
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

  void _handleAddOrEditItem(bool isAdding) async {
    final category = _controller.category.value!;

    if (category.name.isEmpty) {
      _renderErrorDialog('can\'t ${isAdding ? 'add' : 'Edit'} without Name.');
    } else if (category.pic.url == null &&
        category.pic.path == null &&
        category.type != 2) {
      _renderErrorDialog(
          'can\'t ${isAdding ? 'add' : 'Edit'} without Picture.');
    } else {
      _controller.isLoading.value = true;
      bool imageUploadResult = true;

      if (category.type != 2) {
        imageUploadResult = await _controller.uploadImage();
      }

      if (imageUploadResult && _controller.category.value!.pic.url != null) {
        category.index = _controller.currentCategories.length;

        final result = await _controller.setCategories(
            isAdding,
            _homeController.categories
                .where((e) => e.type == category.type)
                .toList());

        if (result) {
          if (isAdding &&
              _controller.selectedCategoryType.value == category.type) {
            _controller.currentCategories.add(category);
          }
          _controller.currentCategories.refresh();
          Get.back();
        }

        Get.defaultDialog(
            title: result ? 'Success' : 'Error!',
            middleText: result
                ? 'Category has been ${isAdding ? 'added' : 'Edited'}.'
                : 'Failed to ${isAdding ? 'add' : 'Edit'} Category, try again.',
            textCancel: 'Ok');
      } else {
        Get.defaultDialog(
            title: 'Error!',
            middleText: 'Failed to upload picture.',
            textCancel: 'Ok');
      }
      _controller.isLoading.value = false;
    }
  }

  void _removeCategory(int index) async {
    final category = _controller.currentCategories[index];
    final result = await _controller.removeCategory(category);
    if (result) {
      _controller.currentCategories.remove(category);
      _controller.updateCategoriesIndexes();
    }
  }

  void _openImagePicker(bool fromCamera) async {
    final image = await imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);

    if (image != null) {
      _controller.category.value!.pic = ImageModel(path: image.path);
      _controller.category.refresh();
    }
  }

  void _openAddImageLinkDialog() {
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
            _controller.category.value!.pic = ImageModel(url: link);
            _controller.category.refresh();
          }
        });
  }

  void _renderErrorDialog(String message) {
    Get.defaultDialog(title: 'Error!', middleText: message, textCancel: 'OK');
  }

  void fillCurrentCategories() {
    _controller.currentCategories.value = _homeController.categories
        .where((e) => e.type == _controller.selectedCategoryType.value)
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));
  }

  void reOrderCategories() {
    final cats = <int, List<CategoryModel>>{};

    for (var c in _homeController.categories) {
      cats.putIfAbsent(c.type, () => []);
      cats[c.type]!.add(c);
    }

    cats.forEach((key, cat) {
      cat.sort((a, b) => a.index.compareTo(b.index));
    });
    _homeController.categories.refresh();
  }

  void updateIndexes() async {
    final result = await _controller.updateCategoriesIndexes();

    Get.defaultDialog(
        title: result ? 'Success' : 'Error!',
        middleText: result
            ? 'Categories indexes has been updated.'
            : 'Categories indexes not updated, please try again',
        textCancel: 'OK');
  }
}
