import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/features/user/data/model/shopping_address_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/shopping_address_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flip_card/flip_card.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({Key? key}) : super(key: key);

  final _controller = Get.put(HomeController());

  final GlobalKey<FlipCardState> _shoppingAddressFlipKey =
      GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopWidget(context),
            Obx(() => _controller.user.value != null &&
                    _controller.user.value!.isAdmin &&
                    !_controller.isLoading.value
                ? _buildCardItem(Icons.admin_panel_settings_outlined,
                    'Admin Panel', () => Get.toNamed(adminPanelScreen))
                : const SizedBox()),
            _buildCardItem(Icons.location_on_outlined, 'Shopping Addresses',
                _showShoppingAddressesBottomSheet),
            _buildCardItem(Icons.list_alt_outlined, 'Orders',
                () => Get.toNamed(ordersScreen)),
            _buildCardItem(Icons.favorite_border, 'Favorite',
                () => _controller.bottomNavBarIndex.value = 2),
            _buildCardItem(
                _controller.isLogin() ? Icons.logout : Icons.login, _controller.isLogin() ? 'Logout' : 'Login', () {
              if (_controller.isLogin()) {
                _controller.logout();
              }
              Get.offAllNamed(loginScreen);
              Get.delete<HomeController>();
            }),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopWidget(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 130,
      child: Stack(
        children: [
          ClipPath(
            clipper: TopWidgetCustomClipper(),
            child: Container(
              width: Get.width,
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Get.height * .25
                  : Get.height * .35,
              decoration: const BoxDecoration(
                color: secondColor,
                gradient: LinearGradient(
                  colors: [primaryColor, secondColor],
                  begin: Alignment.center,
                  end: Alignment.centerRight,
                ),
              ),
              child: !_controller.isLogin()
                  ? const SizedBox()
                  : Obx(
                      () => Row(
                        children: [
                          GestureDetector(
                            onTap: _openImagePickerDialog,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: _controller.user.value?.pic == null ||
                                          _controller.user.value!.pic!.isEmpty
                                      ? const ColoredBox(
                                          color: Colors.amberAccent)
                                      : CachedNetworkImage(
                                          imageUrl:
                                              _controller.user.value!.pic!,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator())),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          height: 100,
                                          width: 100,
                                        ),
                                ),
                              ),
                              margin: const EdgeInsets.only(left: 20, top: 15),
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(65),
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 15),
                            child: SizedBox(
                              width: Get.width * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _controller.user.value?.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Get.textTheme.headline5!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _controller.user.value?.phoneNumber ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Get.textTheme.caption!.copyWith(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 60,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 5),
                      blurRadius: 5)
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  if (_controller.user.value != null) {
                    Get.defaultDialog(
                        title: 'Edit Info',
                        confirmTextColor: Colors.white,
                        content: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: _controller.user.value!.name,
                                onChanged: (v) =>
                                    _controller.user.value!.name = v,
                                decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue:
                                    _controller.user.value!.phoneNumber,
                                onChanged: (v) =>
                                    _controller.user.value!.phoneNumber = v,
                                enabled:
                                    _controller.user.value!.provider != 'phone',
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ],
                          ),
                        ),
                        textConfirm: 'submit',
                        textCancel: 'cancel',
                        onConfirm: () {
                          if (_controller.user.value!.name!.length > 3) {
                            _controller.editUserInfo().then((result) {
                              if (result) {
                                Get.back();
                              }
                            });
                          }
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardItem(
      IconData icon, String text, GestureTapCallback onPress) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onPress,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: Get.textTheme.headline6!.copyWith(color: primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openImagePickerDialog() {
    Get.defaultDialog(
        title: 'Select Target',
        textCancel: 'Cancel',
        content: Column(
          children: [
            TextButton(
                onPressed: () {
                  Get.back();
                  _openImagePicker(ImageSource.camera);
                },
                child: const Text('Camera')),
            TextButton(
                onPressed: () {
                  Get.back();
                  _openImagePicker(ImageSource.gallery);
                },
                child: const Text('Gallery')),
          ],
        ),
        onCancel: () => Get.back());
    //  final imagePicker = ImagePicker().pickImage(source: source);
  }

  void _openImagePicker(ImageSource source) {
    ImagePicker().pickImage(source: source).then((value) async {
      if (value != null) {
        await _controller.updateUserPicture(value.path);
      }
    });
  }

  void _showShoppingAddressesBottomSheet() {
    _controller.addingShoppingAddress.value = ShoppingAddressModel();

    _controller.addingShoppingAddress.value!.phoneNumber =
        _controller.user.value?.phoneNumber ?? '';
    _controller.addingShoppingAddress.value!.email =
        _controller.user.value?.email ?? '';

    Get.bottomSheet(
        FractionallySizedBox(
          heightFactor: 0.75,
          child: FlipCard(
            speed: 300,
            flipOnTouch: false,
            key: _shoppingAddressFlipKey,
            front: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Obx(
                    () => _controller.shoppingAddresses.isEmpty
                        ? Center(
                            child: TextButton(
                              onPressed: () => _shoppingAddressFlipKey
                                  .currentState!
                                  .toggleCard(),
                              child: const Text(
                                'You don`t have any Shopping Addresses, \n Click Here to Add',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _controller.shoppingAddresses.length,
                              itemBuilder: (_, index) => Card(
                                child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.horizontal,
                                    onDismissed: (direction) => _controller
                                        .removeShoppingAddress(_controller
                                            .shoppingAddresses[index]),
                                    background: Container(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        color: Colors.red,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.fromLTRB(0.0,
                                                  0.0, Get.width * 0.02, 0.0),
                                              child: const Icon(
                                                  Icons.delete_outline),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0.0,
                                                  0.0, Get.width * 0.05, 0.0),
                                              child: const Text(
                                                "DELETE",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: ShoppingAddressWidget(
                                        shoppingAddress: _controller
                                            .shoppingAddresses[index],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: MaterialButton(
                      onPressed: () =>
                          _shoppingAddressFlipKey.currentState!.toggleCard(),
                      color: buttonColor,
                      disabledColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Text(
                        'Add Shopping Address',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            back: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.name = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.country = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.city = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.state = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.street = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    decoration: InputDecoration(
                        labelText: 'Street',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.postalCode =
                          int.tryParse(v);
                      _controller.addingShoppingAddress.refresh();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Postal Code',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    initialValue: _controller.user.value?.email ?? '',
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.email = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: _controller.user.value?.phoneNumber ?? '',
                    onChanged: (v) {
                      _controller.addingShoppingAddress.value!.phoneNumber = v;
                      _controller.addingShoppingAddress.refresh();
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => TextButton(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: _validateShoppingAddress(
                                    _controller.addingShoppingAddress.value!)
                                ? buttonColor
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: !_validateShoppingAddress(
                                  _controller.addingShoppingAddress.value!)
                              ? null
                              : () {
                                  _controller.addShoppingAddress(
                                      _controller.addingShoppingAddress.value!);
                                  _shoppingAddressFlipKey.currentState
                                      ?.toggleCard();
                                  _controller.addingShoppingAddress.value =
                                      ShoppingAddressModel();
                                })),
                      TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: buttonColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () =>
                            _shoppingAddressFlipKey.currentState!.toggleCard(),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Get.theme.primaryColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular((20))),
        ));
  }

  bool _validateShoppingAddress(ShoppingAddressModel shoppingAddress) {
    return shoppingAddress.name != null &&
        shoppingAddress.name!.length > 4 &&
        shoppingAddress.country != null &&
        shoppingAddress.country!.length > 2 &&
        shoppingAddress.city != null &&
        shoppingAddress.city!.length > 2 &&
        shoppingAddress.street != null &&
        shoppingAddress.street!.length > 2 &&
        shoppingAddress.state != null &&
        shoppingAddress.state!.length > 2 &&
        shoppingAddress.email != null &&
        GetUtils.isEmail(shoppingAddress.email!) &&
        shoppingAddress.phoneNumber != null &&
        GetUtils.isPhoneNumber(shoppingAddress.phoneNumber!) &&
        shoppingAddress.postalCode != null &&
        shoppingAddress.postalCode! > 100;
  }
}

class TopWidgetCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 150;

    Path path = Path()
      ..lineTo(size.width - radius, 0)
      ..lineTo(size.width, size.height - radius)
      ..arcTo(
          Rect.fromCircle(
              center: Offset(size.width - radius, size.height - radius),
              radius: radius),
          0,
          0.5 * pi,
          false)
      ..lineTo(radius, size.height)
      ..lineTo(0, radius)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
