import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ring_shop_list/core/notifiers/generic_state.dart';
import 'package:ring_shop_list/core/utils/constants.dart';
import 'package:ring_shop_list/core/utils/ui_utils.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
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
        fetchShops();
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
  int offset = 0;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              await fetchShops(refresh: true);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shops',
                  style: context.theme.textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Height(30),
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

                    // return const Placeholder();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onScroll() async {
    double max = _scrollController.position.maxScrollExtent;
    double pixels = _scrollController.position.pixels;
    double scrollOffset = _scrollController.offset;

    if (pixels == max && (context.read(paginationProvider).hasMore)) {
      context.read(paginationProvider).incrementOffset(10);
      await fetchMoreShops();
    }
  }

  Future<void> fetchShops({bool refresh = false}) async {
    var state = await context.read(shopListVm.notifier).fetchShops(
          'lille',
          limit: 10,
          offset: refresh ? 0 : context.read(paginationProvider).offset,
        );

    if (state is Loaded<ShopListModel>) {
      var value = state.value!;
      totalPages = (value.shopCount / limit).floor();
      currentPage = offset ~/ limit;

      refresh ? _shopList = value.shops : _shopList.addAll(value.shops);

      context.read(paginationProvider).setHasMore(currentPage < totalPages);
    }
  }

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

class ShopItemWidget extends ConsumerWidget {
  const ShopItemWidget({Key? key, required this.items, required this.index})
      : super(key: key);

  final int index;
  final List<ShopListData> items;

  @override
  Widget build(BuildContext context, watch) {
    var state = watch(shopListVm);

    if (state is Loaded<ShopListModel>) {
      ShopListData shop = items[index];

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: CachedNetworkImage(
                    imageUrl: shop.coverUrl!.imgKitSize(70, 70),
                    placeholder: (context, url) {
                      return Image.network(shop.coverUrl!.imgKitBlur(70, 70));
                    },
                  ),
                ),
              ),
              Width(13),
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: context.theme.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Height(5),
                    RichText(
                      text: TextSpan(
                        style: context.theme.textTheme.bodyText1!.copyWith(
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(text: '${shop.distanceInMeters} m '),
                          WidgetSpan(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 2, left: 1),
                            child: Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.indigo[600],
                            ),
                          )),
                          TextSpan(
                            text: '${shop.averageRating ?? 'N/A'}  ',
                            style: TextStyle(color: Colors.indigo[600]),
                          ),
                          TextSpan(
                            text: '(${shop.reviewCount})',
                            style: TextStyle(
                              color: Colors.indigo[600]!.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Height(5),
                    Text(
                      shop.activityNames?[0] ?? '',
                      style: context.theme.textTheme.bodyText1!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                size: 30,
                color: Colors.grey,
              ),
            ],
          ),
          Height(20),
          SizedBox(
            height: 100,
            child: ListView.separated(
              itemCount: shop.products?.length ?? 0,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (_, __) {
                return Width(4);
              },
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: shop.products?[i]?.master?.illustrationUrl
                              ?.imgKitSize(100, 100) ??
                          Constants.productStockImg,
                    ),
                  );
                }
                return CachedNetworkImage(
                  imageUrl: shop.products?[i]?.master?.illustrationUrl
                          ?.imgKitSize(100, 100) ??
                      Constants.productStockImg,
                );
              },
            ),
          ),
        ],
      );
    }

    return Container();
  }
}
