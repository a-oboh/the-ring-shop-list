import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';

import '../../../../data/data_reader.dart';

void main() {
  Map<String, dynamic> jsonToMap() {
    final String jsonString = dataReader('shop_list/shop_list.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  group(
    'fromJson',
    () {
      test('should return a valid model when fromJson is called', () {
        final result = ShopListModel.fromJson(jsonToMap());

        expect(result.shops[0].id, 'afb62700-d2e2-45f5-ace7-3eb883e21b4c');
      });
    },
  );
}
