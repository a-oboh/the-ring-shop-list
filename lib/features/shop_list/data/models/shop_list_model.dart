import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'shop_list_model.freezed.dart';
part 'shop_list_model.g.dart';

ShopListModel shopListFromJson(String rawJson) =>
    ShopListModel.fromJson(json.decode(rawJson));

@freezed
class ShopListModel with _$ShopListModel {
  const factory ShopListModel({
    required List<ShopListData> shops,
    @JsonKey(name: 'shop_count') required int shopCount,
  }) = _ShopListModel;

  factory ShopListModel.fromJson(Map<String, dynamic> json) =>
      _$ShopListModelFromJson(json);
}

@freezed
class ShopListData with _$ShopListData {
  const factory ShopListData({
    required String id,
    String? slug,
    @JsonKey(name: 'cover_url') String? coverUrl,
    required String name,
    required Address address,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    required City city,
    List<SingleProduct?>? products,
    @JsonKey(name: 'average_rating') double? averageRating,
    @JsonKey(name: 'review_count') int? reviewCount,
    @JsonKey(name: 'activity_names') List<String?>? activityNames,
    @JsonKey(name: 'is_favourite') bool? isFavourite,
    @JsonKey(name: 'distance_in_meters') int? distanceInMeters,
  }) = _ShopListData;

  factory ShopListData.fromJson(Map<String, dynamic> json) =>
      _$ShopListDataFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    required String address1,
    @JsonKey(name: 'zip_code') String? zipCode,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    required String id,
    String? slug,
    required String name,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'zip_code') String? zipCode,
    String? country,
    @JsonKey(name: 'country_details') CountryDetails? countryDetails,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class CountryDetails with _$CountryDetails {
  const factory CountryDetails({
    required String name,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'language_code') String? languageCode,
  }) = _CountryDetails;

  factory CountryDetails.fromJson(Map<String, dynamic> json) =>
      _$CountryDetailsFromJson(json);
}

// @freezed
// class Products with _$Products {
//   const factory Products({
//     required List<SingleProduct> products,
//   }) = _Products;

//   factory Products.fromJson(Map<String, dynamic> json) =>
//       _$ProductsFromJson(json);
// }

@freezed
class SingleProduct with _$SingleProduct {
  const factory SingleProduct({
    String? id,
    Master? master,
  }) = _Product;

  factory SingleProduct.fromJson(Map<String, dynamic> json) =>
      _$SingleProductFromJson(json);
}

@freezed
class Master with _$Master {
  const factory Master({
    String? id,
    String? currency,
    @JsonKey(name: 'tax_included_price_in_cents') int? taxIncludedPriceInCents,
    @JsonKey(name: 'illustration_url') String? illustrationUrl,
    String? name,
    int? stock,
  }) = _Master;

  factory Master.fromJson(Map<String, dynamic> json) => _$MasterFromJson(json);
}
