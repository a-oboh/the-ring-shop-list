import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ring_shop_list/features/shop_list/data/data_sources/shop_list_remote_datasource.dart';
import 'package:ring_shop_list/features/shop_list/domain/repositories/shop_list_repository.dart';
import 'package:ring_shop_list/features/shop_list/domain/usecases/get_list_from_city.dart';
import 'package:ring_shop_list/features/shop_list/presentation/notifiers/pagination_change_notifier.dart';
import 'package:ring_shop_list/features/shop_list/presentation/view_models/shop_list_vm.dart';

import 'core/utils/network_info.dart';

final sl = GetIt.instance;

// ignore_for_file: cascade_invocations
Future<void> init() async {
  //VMs
  sl.registerLazySingleton<ShopListVm>(
    () => ShopListVm(sl()),
  );
  sl.registerLazySingleton<PaginationChangeNotifier>(
    () => PaginationChangeNotifier(),
  );

  //data sources
  sl.registerLazySingleton<ShopListRemoteDataSource>(
    () => ShopListRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  //use cases
  sl.registerLazySingleton(() => GetShopsFromCity(sl()));

  //repositories
  sl.registerLazySingleton<ShopListRepository>(
    () => ShopListRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()),
  );

  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //external
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
