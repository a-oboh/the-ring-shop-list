import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ring_shop_list/core/notifiers/generic_state.dart';
import 'package:ring_shop_list/core/utils/constants.dart';
import 'package:ring_shop_list/core/utils/size_config.dart';
import 'package:ring_shop_list/core/utils/ui_utils.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
import 'package:ring_shop_list/features/shop_list/presentation/views/shop_list_item.dart';
import 'package:ring_shop_list/providers.dart';
import '../../../../core/utils/extensions.dart';

class ShopListView extends StatefulWidget {
  const ShopListView({Key? key}) : super(key: key);

  @override
  _ShopListViewState createState() => _ShopListViewState();
}

class _ShopListViewState extends State<ShopListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) async {
        //fetch first shop page
        await fetchShops();
      },
    );
  }

  final _scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  List<ShopListData> _shopList = [];
  bool hasMore = false;
  int totalPages = 1;
  int currentPage = 1;

  int limit = 10;

  @override
  Widget build(BuildContext context) {
    //scroll listener for our shop list view to handle infinite scroll
    _scrollController.addListener(_onScroll);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              //refresh list on pull down
              await fetchShops(refresh: true);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Height(15),
                Text(
                  'Shops',
                  style: context.theme.textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Height(20),
                Consumer(
                  builder: (_, watch, child) {
                    final state = watch(shopListVm);
                    final pageProvider = watch(paginationProvider);

                    if (state is Loading && _shopList.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                      );
                    }

                    if (state is Error) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                state.message,
                                style: context.theme.textTheme.subtitle1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Height(10),
                            TextButton.icon(
                              onPressed: () async {
                                await fetchShops();
                              },
                              icon: const Icon(Icons.refresh_outlined),
                              label: const Text('Retry'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: _shopList.length,
                        itemBuilder: (ctx, i) {
                          //show a progress indicator when loading next page
                          if (i == _shopList.length - 1 &&
                              pageProvider.hasMore) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.black),
                                  ),
                                ),
                              ),
                            );
                          }

                          return ShopItemWidget(index: i, items: _shopList);
                        },
                        separatorBuilder: (ctx, i) => Container(
                          height: 1,
                          width: context.width(1),
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //handle infinite scroll on hitting listview bottom
  void _onScroll() async {
    double max = _scrollController.position.maxScrollExtent;
    double pixels = _scrollController.position.pixels;
    double scrollOffset = _scrollController.offset;

    if (pixels == max && (context.read(paginationProvider).hasMore)) {
      context.read(paginationProvider).incrementOffset(10);
      await fetchMoreShops();
    }
  }

  //Fetch Shop list
  Future<void> fetchShops({bool refresh = false}) async {
    var state = await context.read(shopListVm.notifier).fetchShops(
          'lille',
          limit: 10,
          offset: refresh ? 0 : context.read(paginationProvider).offset,
        );

    if (state is Loaded<ShopListModel>) {
      var value = state.value!;
      totalPages = (value.shopCount / limit).floor();
      currentPage = context.read(paginationProvider).offset ~/ limit;

      refresh ? _shopList = value.shops : _shopList.addAll(value.shops);

      context.read(paginationProvider).setHasMore(currentPage < totalPages);
    }
  }

  //fetch more shops for infinite scroll
  Future<void> fetchMoreShops() async {
    var state = await context.read(shopListVm.notifier).fetchMoreShops('lille',
        limit: limit, offset: context.read(paginationProvider).offset);

    if (state is Loaded<ShopListModel>) {
      var value = state.value!;
      totalPages = (value.shopCount / limit).floor();
      currentPage = context.read(paginationProvider).offset ~/ limit;

      _shopList.addAll(value.shops);

      context.read(paginationProvider).setHasMore(currentPage < totalPages);
    }
  }
}
