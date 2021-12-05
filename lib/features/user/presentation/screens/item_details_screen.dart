import 'package:ecommerce/features/user/data/model/cart_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/logic/item_controller.dart';
import 'package:ecommerce/features/user/presentation/logic/payment_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/cart_item_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class ItemDetailsScreen extends StatelessWidget {
  ItemDetailsScreen({Key? key, required this.itemId}) : super(key: key) {
    _controller = Get.put(ItemController(itemId));
  }

  late final ItemController _controller;
  final _homeController = Get.put(HomeController());
  final _paymentController = Get.put(PaymentController());

  final _pageController = PageController();

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Get.delete<ItemController>();
          return Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: _buildBottomWidgets(),
            body: Obx(
              () {
                if (!_controller.isLoading.value &&
                    _controller.item.value == null) {
                  _homeController.removeFavoriteItem(itemId);
                  Get.back();
                }
                return _controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _controller.item.value != null
                        ? SingleChildScrollView(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSlider(),
                              _buildRatingWidget(),
                              _buildName(),
                              _buildPrice(),
                              if (_controller.item.value!.colors.isNotEmpty)
                                _buildSmallTitle('Colors'),
                              if (_controller.item.value!.colors.isNotEmpty)
                                _buildColors(false),
                              if (_controller.item.value!.colors.isNotEmpty)
                                _buildSmallTitle('Sizes'),
                              if (_controller.item.value!.sizes.isNotEmpty)
                                _buildSizes(false),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ))
                        : const SizedBox();
              },
            ),
          ),
        ));
  }

  Widget _buildBottomWidgets() {
    return Container(
      width: Get.width,
      height: 75,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 2), blurRadius: 5)
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Row(
        children: [
          const BackButton(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() => MaterialButton(
                  onPressed: !_controller.isLoading.value &&
                          _controller.item.value != null &&
                          _controller.item.value!.inStock
                      ? _showSelectorsBottomSheet
                      : null,
                  color: buttonColor,
                  disabledColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )),
          )),
          Obx(() {
            final isFavorite = _homeController.favorites
                    .firstWhereOrNull((e) => e.id == itemId) !=
                null;

            return IconButton(
              icon: SizedBox(
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                ),
              ),
              color: isFavorite ? buttonColor : Get.theme.shadowColor,
              iconSize: 16,
              splashRadius: 15,
              onPressed: () => isFavorite
                  ? _homeController
                      .removeFavoriteItem(_controller.item.value!.id!)
                  : _homeController.addFavoriteItem(_controller.item.value!),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: SizedBox(
        width: Get.width,
        height: 350,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _controller.item.value!.pics.length,
              onPageChanged: (v) {
                _controller.selectedImageIndex.value = v;
              },
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => Get.toNamed(imageZoomScreen,
                    arguments: [_controller.item.value!.pics[index]]),
                child: index == 0
                    ? Hero(
                        tag: _controller.item.value!.hashCode,
                        child: ImageWidget(
                            image: _controller.item.value!.pics[index],
                            height: 200,
                            width: Get.width),
                      )
                    : ImageWidget(
                        image: _controller.item.value!.pics[index],
                        height: 200,
                        width: Get.width),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        _controller.item.value!.pics.length,
                        (index) => GestureDetector(
                            onTap: () {
                              if (_controller.selectedImageIndex.value !=
                                  index) {
                                _pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              }
                            },
                            child: Obx(() => AnimatedContainer(
                                  height: 10,
                                  width: 10,
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: _controller
                                                  .selectedImageIndex.value ==
                                              index
                                          ? Colors.white
                                          : Colors.white38),
                                )))).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatingWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RatingBar.builder(
            initialRating: _controller.item.value!.rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 18,
            itemPadding: const EdgeInsets.symmetric(horizontal: 0.3),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.orange,
            ),
            maxRating: 5,
            ignoreGestures: true,
            updateOnDrag: false,
            tapOnlyMode: false,
            glow: false,
            onRatingUpdate: (v) {},
          ),
          Text(
            '${_controller.item.value!.inStock ? 'In' : 'Out'} Stock',
            style: Get.textTheme.bodyText1!.copyWith(
                color:
                    _controller.item.value!.inStock ? Colors.green : Colors.red,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        _controller.item.value!.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Get.textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.7)),
      ),
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Row(
        children: [
          if (_controller.item.value!.discount > 0)
            Text(
              '\$${_controller.item.value!.discount.toStringAsFixed(_controller.item.value!.discount.toString().endsWith('.0') ? 0 : 1)}',
              style: Get.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: _controller.item.value!.discount > 0
                      ? const Color(0xffBE4A3A)
                      : Colors.black),
            ),
          if (_controller.item.value!.discount > 0)
            const SizedBox(
              width: 10,
            ),
          Text(
            '\$${_controller.item.value!.price.toStringAsFixed(_controller.item.value!.price.toString().endsWith('.0') ? 0 : 1)}',
            style: Get.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: _controller.item.value!.discount > 0
                    ? Colors.grey
                    : Colors.black,
                decoration: _controller.item.value!.discount > 0
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: Get.textTheme.bodyText2!
            .copyWith(color: Colors.grey, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildColors(bool choiceEnable) {
    return SizedBox(
      width: Get.width,
      height: 75,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _controller.item.value!.colors
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    child: GestureDetector(
                        onTap: () => choiceEnable
                            ? _controller.selectedColor.value = e
                            : Get.toNamed(imageZoomScreen, arguments: [e]),
                        child: Obx(
                          () => SizedBox(
                            height: 75,
                            width: 55,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ColoredBox(
                                    color:
                                        _controller.selectedColor.value == e &&
                                                choiceEnable
                                            ? buttonColor
                                            : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ImageWidget(
                                            image: e,
                                            width: double.maxFinite,
                                            height: double.maxFinite),
                                      ),
                                    ))),
                          ),
                        )),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSizes(bool choiceEnable) {
    return SizedBox(
      width: Get.width,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _controller.item.value!.sizes
              .map((e) => GestureDetector(
                    onTap: choiceEnable
                        ? () => _controller.selectedSize.value = e
                        : null,
                    child: Obx(() => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: _controller.selectedSize.value == e &&
                                      choiceEnable
                                  ? buttonColor
                                  : Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(.7),
                                  width: 1)),
                          child: Center(child: Text(e)),
                        )),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showSelectorsBottomSheet() {
    Get.bottomSheet(
        FractionallySizedBox(
            heightFactor: 0.65,
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => CartItemWidget(
                            item: _controller.item.value!,
                            count: _controller.itemCount.value,
                            onIncrease: () => _controller.itemCount.value++,
                            onDecrease: () {
                              if (_controller.itemCount.value > 1) {
                                _controller.itemCount.value--;
                              }
                            },
                          )),
                      if (_controller.item.value!.colors.isNotEmpty)
                        _buildSmallTitle('Colors'),
                      if (_controller.item.value!.colors.isNotEmpty)
                        _buildColors(true),
                      if (_controller.item.value!.colors.isNotEmpty)
                        _buildSmallTitle('Sizes'),
                      if (_controller.item.value!.sizes.isNotEmpty)
                        _buildSizes(true),
                    ],
                  ),
                )),
                SizedBox(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: MaterialButton(
                      onPressed: _addToCart,
                      color: buttonColor,
                      disabledColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            )),
        isScrollControlled: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular((20))),
        ));
  }

  void _addToCart() {
    if (_controller.selectedColor.value == null &&
        _controller.item.value!.colors.length > 1) {
      _renderDialog('Color');
    } else if (_controller.selectedSize.value == null &&
        _controller.item.value!.sizes.length > 1) {
      _renderDialog('Size');
    } else {

      if (_controller.selectedColor.value == null && _controller.item.value!.colors.isNotEmpty){
        _controller.selectedColor.value = _controller.item.value!.colors.first;
      }
      if (_controller.selectedSize.value == null && _controller.item.value!.sizes.isNotEmpty) {
        _controller.selectedSize.value = _controller.item.value!.sizes.first;
      }

        _paymentController.addCartItem(CartModel(
          itemId: _controller.item.value!.id!,
          selectedColor: _controller.selectedColor.value,
          selectedSize: _controller.selectedSize.value,
          wallImage: _controller.item.value!.pics.first,
          count: _controller.itemCount.value));
      _controller.itemCount.value = 1;
      _controller.selectedSize.value = null;
      _controller.selectedColor.value = null;

      Get.back();
      Get.defaultDialog(
        title: 'Success!',
        middleText: 'The Item has Added to Cart.',
        textConfirm: 'Go to Cart',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          Get.toNamed(cartScreen);
        },
        textCancel: 'Continue Shopping',
      );
    }
  }

  void _renderDialog(String type) {
    Get.defaultDialog(
        title: type + '!',
        middleText: 'please choice a $type.',
        textConfirm: 'Ok',
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back());
  }
}
