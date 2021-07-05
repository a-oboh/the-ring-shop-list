import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ring_shop_list/core/error/exception.dart';
import 'package:ring_shop_list/core/error/failure.dart';
import 'package:ring_shop_list/core/utils/network_info.dart';
import 'package:ring_shop_list/features/shop_list/data/data_sources/shop_list_remote_datasource.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
import 'package:ring_shop_list/features/shop_list/domain/repositories/shop_list_repository.dart';

import '../../../../data/data_reader.dart';

class MockShopListRemoteDataSource extends Mock
    implements ShopListRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockShopListRemoteDataSource mockRemoteDataSource;
  late ShopListRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;
  late ShopListModel shopsModel;

  Map<String, dynamic> jsonToMap() {
    final String jsonString = dataReader('shop_list/shop_list.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  setUpAll(() {
    shopsModel = ShopListModel.fromJson(jsonToMap());
  });

  setUp(() {
    mockRemoteDataSource = MockShopListRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ShopListRepositoryImpl(
        remoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getShopListFromCity', () {
    runTestsOnline(() {
      test('should return data when successful', () async {
        when(() => mockRemoteDataSource.getShopListFromCity('lille',
            limit: 0, offset: 0)).thenAnswer((_) async => shopsModel);

        final result =
            await repository.getShopListFromCity('lille', limit: 0, offset: 0);

        verify(() => mockRemoteDataSource.getShopListFromCity('lille',
            limit: 0, offset: 0)).called(1);

        expect(result, equals(Right(shopsModel)));
      });

      test(
        'should return failure when call to remote data source is unsuccessful',
        () async {
          when(() => mockRemoteDataSource.getShopListFromCity('lille'))
              .thenThrow(ServerException());

          final result = await repository.getShopListFromCity('lille');

          verify(() => mockRemoteDataSource.getShopListFromCity('lille'))
              .called(1);

          expect(result, equals(const Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return network failure when the isConnected is false',
        () async {
          final result = await repository.getShopListFromCity('lille');

          expect(result, equals(const Left(NetworkFailure())));
        },
      );
    });
  });
}
