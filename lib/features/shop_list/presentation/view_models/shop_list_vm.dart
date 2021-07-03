import 'package:ring_shop_list/core/notifiers/generic_state_notifier.dart';
import 'package:ring_shop_list/features/shop_list/data/models/shop_list_model.dart';
import 'package:ring_shop_list/features/shop_list/domain/usecases/get_list_from_city.dart';

class ShopListVm extends GenericStateNotifier<ShopListModel> {
  ShopListVm(this.similarTv);

  final GetShopsFromCity similarTv;

  void fetchShops(String city) {
    sendRequest(() async {
      return await similarTv(Params(city: city));
    });
  }
}
