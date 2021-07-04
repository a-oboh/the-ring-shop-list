import 'package:ring_shop_list/core/notifiers/generic_state.dart';
import 'package:ring_shop_list/core/notifiers/generic_state_notifier.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
import 'package:ring_shop_list/features/shop_list/domain/usecases/get_list_from_city.dart';

class ShopListVm extends GenericStateNotifier<ShopListModel> {
  ShopListVm(this.similarTv);

  final GetShopsFromCity similarTv;

  Future<GenericState<ShopListModel>> fetchShops(String city,
      {int limit = 10, int offset = 0}) {
    return sendRequest(() async {
      return await similarTv(Params(city: city, limit: limit, offset: offset));
    });
  }

  Future<GenericState<ShopListModel>> fetchMoreShops(String city,
      {int limit = 10, int offset = 0}) async {
    // state = GenericState<ShopListModel>.loading();
    final response =
        await similarTv(Params(city: city, limit: limit, offset: offset));

    return response.fold(
      (failure) =>
          state = GenericState<ShopListModel>.error(failure.message ?? ''),
      (success) => state = GenericState<ShopListModel>.loaded(success),
    );

    // return sendRequest(() async {
    //   return await similarTv(Params(city: city, limit: limit, offset: offset));
    // });
  }
}
