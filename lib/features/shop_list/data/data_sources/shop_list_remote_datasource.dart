import 'dart:io';

import 'package:ring_shop_list/core/error/exception.dart';
import 'package:ring_shop_list/core/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';

abstract class ShopListRemoteDataSource {
  Future<ShopListModel> getShopListFromCity(String city,
      {int limit = 0, int offset = 0});
  Future<ShopListModel> getShopListFromGeoData(double long, double lat,
      {int limit = 0, int offset = 0});
}

class ShopListRemoteDataSourceImpl extends ShopListRemoteDataSource {
  ShopListRemoteDataSourceImpl({required this.client});

  final http.Client client;

  @override
  Future<ShopListModel> getShopListFromCity(String city,
      {int limit = 0, int offset = 0}) async {
    try {
      final response = await client.get(Uri.parse(
          ApiUrls.getShopsWithCity(city: city, limit: limit, offset: offset)));

      if (response.statusCode == 200) {
        return shopListFromJson(response.body);
      } else if (response.statusCode == 400) {
        throw BadRequestException(
            message:
                // ignore: lines_longer_than_80_chars
                'Something went wrong :(, please check that you inputed the correct city');
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } catch (e, s) {
      print(e);
      print(s);

      client.close();
      
      throw ServerException(stack: s);
    }
  }

  @override
  Future<ShopListModel> getShopListFromGeoData(double long, double lat,
      {int limit = 0, int offset = 0}) {
    // TODO: implement getShopListFromGeoData
    throw UnimplementedError();
  }
}
