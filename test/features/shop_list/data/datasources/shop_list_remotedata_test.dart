import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ring_shop_list/core/error/exception.dart';
import 'package:ring_shop_list/core/utils/urls.dart';
import 'package:ring_shop_list/features/shop_list/data/data_sources/shop_list_remote_datasource.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';

import '../../../../data/data_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient client;
  late ShopListRemoteDataSourceImpl dataSource;
  Uri url =
      Uri.parse(ApiUrls.getShopsWithCity(city: 'lille', limit: 0, offset: 0));

  setUp(() {
    client = MockClient();
    dataSource = ShopListRemoteDataSourceImpl(client: client);
  });

  group('get shops by city', () {
    test('returns ShopList if the call completes successfully', () async {
      when(() => client.get(url)).thenAnswer((_) async =>
          http.Response(dataReader('shop_list/shop_list.json'), 200));

      expect(
          await dataSource.getShopListFromCity('lille'), isA<ShopListModel>());
    });

    test('throws an exception if the http call completes with an error',
        () async {
      //testing with 404 response
      when(() => client.get(url))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => dataSource.getShopListFromCity('lille'),
        throwsA(isA<ServerException>()),
      );

      // verify(() => dataSource.getShopListFromCity('lille')).called(1);
    });
  });
}
