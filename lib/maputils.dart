import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(String origin, String destiny) async {
    String googleMapurl =
        "https://www.google.com/maps/dir/$origin/$destiny/";
    try {
      await launch(googleMapurl);
    } catch (e) {
      throw e;
    }
  }
}
