import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ring_shop_list/core/utils/constants.dart';
import 'package:ring_shop_list/core/utils/ui_utils.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
import 'package:ring_shop_list/providers.dart';
import '../../../../core/utils/extensions.dart';

class ShopItemWidget extends ConsumerWidget {
  const ShopItemWidget({Key? key, required this.items, required this.index})
      : super(key: key);

  final int index;
  final List<ShopListData> items;

  @override
  Widget build(BuildContext context, watch) {

    ShopListData shop = items[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              //clip sides
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
}
