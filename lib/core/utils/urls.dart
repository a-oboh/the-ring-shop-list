class ApiUrls {
  static const baseUrl = 'https://api.the-ring.io/customers/browse/shops';

  static String getShopsWithCity(
          {required String city, int limit = 0, int offset = 0}) =>
      '$baseUrl?city=$city&limit=$limit&offset=$offset';
}
