import 'package:url_launcher/url_launcher.dart';

void openGoogleMaps({
  required String? url,
}) async {
  String googleMapsUrl;

  if (url != null) {
    // Case 1: Open the direct Google Maps link from backend
    googleMapsUrl = url;
  } else {
    // Invalid case

    return;
  }

  Uri uri = Uri.parse(googleMapsUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print("Could not launch Google Maps");
  }
}