class MapApi {
  static String url =
      'https://static-maps.yandex.ru/v1?apikey=7000f134-f841-406a-b0fb-89cb84cc282d';
  static String urlForMap(x, y) {
    print('$url&ll=$x,$y&z=16&pt=$x,$y,org&size=300,400');
    return '$url&ll=$x,$y&z=16&pt=$x,$y,org&size=300,400';
  }

  static String urlRandom() {
    final x = 37.802688;
    final y = 48.003454;

    return '$url&ll=$x,$y&z=13&size=300,400';
  }
}
