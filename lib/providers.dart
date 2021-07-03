import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ring_shop_list/features/shop_list/presentation/view_models/shop_list_vm.dart';
import './service_locator.dart' as di;

import 'core/notifiers/generic_state.dart';

final shopListVm = StateNotifierProvider<ShopListVm, GenericState<void>>((ref) {
  return di.sl<ShopListVm>();
});
