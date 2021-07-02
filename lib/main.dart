import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ring_shop_list/core/theme/custom_theme.dart';
import 'service_locator.dart' as di;

void main() async {
  //initialize dependency injection
  await di.init();

  runApp(ProviderScope(child: ShopList()));
}

class ShopList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop List',
      theme: CustomTheme.themeData,
      home: Container(),
    );
  }
}
