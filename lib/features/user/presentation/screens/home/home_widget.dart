import 'package:ecommerce/features/user/data/model/category_model.dart';
import 'package:ecommerce/features/user/presentation/logic/home_controller.dart';
import 'package:ecommerce/features/user/presentation/widgets/image_widget.dart';
import 'package:ecommerce/features/user/presentation/widgets/item_widget.dart';
import 'package:ecommerce/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);
  final _controller = Get.put(HomeController());
  final _sliderPageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: _controller.isLoading.value
                ? [
                    _buildTopWidget(context),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Get.height * .3),
                      child: const CircularProgressIndicator(),
                    )
                  ]
                : [
                    _buildTopWidget(context),
                    _buildSliders(context),
                    _buildCategoriesHeader(),
                    _buildCategories(),
                    _buildSubCategories(),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopWidget(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 150,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? Get.height * .15
                : Get.height * .25,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondColor],
                begin: Alignment.center,
                end: Alignment.topRight,
              ),
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: Get.textTheme.headline3,
                  children: const [
                    TextSpan(
                        text: 'My',
                        style: TextStyle(
                            color: buttonColor,
                            fontSize: 20,
                            fontFamily: 'Anton')),
                    TextSpan(
                        text: 'Shop',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Anton')),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: GestureDetector(
              onTap: () => Get.toNamed(searchScreen),
              child: SizedBox(
                height: 45,
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 20),
                              blurRadius: 5)
                        ]),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'What are you looking for?',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.caption!.copyWith(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliders(BuildContext context) {
    return Container(
      width: Get.width,
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? Get.height * .25
          : Get.height * .40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Obx(
          () {
            final sliders = _controller.categories
                .where((e) => e.type == 1)
                .toList()
              ..sort((a, b) => a.index.compareTo(b.index));

            return Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _sliderPageController,
                  itemCount: sliders.length,
                  onPageChanged: (index) =>
                      _controller.sliderIndex.value = index,
                  itemBuilder: (_, index) {
                    final sliderItem = sliders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            ImageWidget(
                              image: sliderItem.pic,
                              width: Get.width,
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? Get.height * .25
                                  : Get.height * .40,
                            ),
                            const Positioned.fill(
                                child: ColoredBox(
                              color: Colors.black26,
                            )),
                            Positioned(
                              left: 15,
                              top: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' ${sliderItem.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 30),
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'See More ?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () => Get.toNamed(categoryScreen,
                                        arguments: sliderItem),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 5,
                  child: Row(
                    children: List.generate(
                      sliders.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Obx(
                            () => GestureDetector(
                              onTap: _controller.sliderIndex.value == index
                                  ? null
                                  : () => _sliderPageController.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInCubic),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: 5,
                                width: (Get.width - 100) / sliders.length,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(
                                        _controller.sliderIndex.value == index
                                            ? .99
                                            : .2)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Categories',
            style:
                Get.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => _controller.bottomNavBarIndex.value = 1,
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) =>
                        Colors.grey.withOpacity(.4))),
            child: Text(
              'See All',
              style: Get.textTheme.caption!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 80,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () {
            final categories = _controller.categories
                .where((e) => e.type == 0)
                .toList()
              ..sort((a, b) => a.index.compareTo(b.index));

            return categories.isEmpty
                ? const SizedBox()
                : GridView.builder(
                    itemCount: categories.length > 7 ? 7 : categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () =>
                            Get.toNamed(categoryScreen, arguments: category),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              ImageWidget(
                                image: category.pic,
                                width: Get.width,
                                height: 80,
                              ),
                              const Positioned.fill(
                                  child: ColoredBox(
                                color: Colors.black26,
                              )),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ' ${category.name}',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 25,
                            childAspectRatio: .9),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildSubCategories() {
    return Obx(
      () {
        final subCats = _controller.categories
            .where((e) => e.type == 2)
            .toList()
          ..sort((a, b) => a.index.compareTo(b.index));

        return Column(
          children: subCats.map((e) => _buildSubCategory(e)).toList(),
        );
      },
    );
  }

  Widget _buildSubCategory(CategoryModel subCategory) {
    if (subCategory.items == null || subCategory.items!.isEmpty) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(categoryScreen, arguments: subCategory),
              child: Text(
                subCategory.name,
                style: Get.textTheme.headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Get.width,
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subCategory.items?.length ?? 0,
                itemBuilder: (_, index) => SizedBox(
                    width: Get.width * .47,
                    child: Hero(
                        tag: subCategory.items![index].hashCode,
                        child: ItemWidget(item: subCategory.items![index]))),
              ),
            )
          ],
        ),
      );
    }
  }
}
