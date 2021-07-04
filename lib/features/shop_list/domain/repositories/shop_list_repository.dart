import 'package:dartz/dartz.dart';
import 'package:ring_shop_list/core/error/exception.dart';

import 'package:ring_shop_list/core/error/failure.dart';
import 'package:ring_shop_list/core/utils/network_info.dart';
import 'package:ring_shop_list/features/shop_list/data/data_sources/shop_list_remote_datasource.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';

abstract class ShopListRepository {
  Future<Either<Failure, ShopListModel>> getShopListFromCity(String city,
      {int limit = 0, int offset = 0});

  Future<Either<Failure, ShopListModel>> getShopListFromGeoData(
      double long, double lat,
      {int limit = 0, int offset = 0});
}

class ShopListRepositoryImpl extends ShopListRepository {
  ShopListRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ShopListRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, ShopListModel>> getShopListFromCity(String city,
      {int limit = 0, int offset = 0}) async {
    try {
      var isConnected = await networkInfo.isConnected;
      if (isConnected) {
        try {
          final remote = await remoteDataSource.getShopListFromCity(city,
              limit: limit, offset: offset);
          return Right(remote);
        } on ServerException {
          return const Left(ServerFailure());
        } on BadRequestException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ShopListModel>> getShopListFromGeoData(
      double long, double lat,
      {int limit = 0, int offset = 0}) {
    // TODO: implement getShopListFromGeoData
    throw UnimplementedError();
  }
}
