import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ring_shop_list/core/error/failure.dart';
import 'package:ring_shop_list/core/usecases/usecase.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
import 'package:ring_shop_list/features/shop_list/domain/repositories/shop_list_repository.dart';

class GetShopsFromCity extends UseCase<ShopListModel, Params> {
  GetShopsFromCity(this.repository);

  final ShopListRepository repository;

  //single usecase call method
  @override
  Future<Either<Failure, ShopListModel>> call(Params params) async {
    return await repository.getShopListFromCity(params.city,
        limit: params.limit, offset: params.offset);
  }
}

//Parameters for use case call
class Params extends Equatable {
  const Params({required this.city, this.limit = 0, this.offset = 0});

  final String city;
  final int limit;
  final int offset;

  @override
  List<Object> get props => [city];
}
