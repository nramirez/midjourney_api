library midjourney_api;

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

/// Unofficial Dart API for the MidJourney API.
class MidJourneyApi {
  final topUrl = 'https://www.midjourney.com/showcase/top/';
  final recentUrl = 'https://www.midjourney.com/showcase/recent/';

  /// Extracts image urls from the response body
  Future<List<String>> _getImages({required String url}) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final images = extractImageUrls(response.body);
      final urls = images.toSet().toList();

      return List<String>.from(urls);
    } catch (e) {
      log('failed to get images from midjourney $e');
      return [];
    }
  }

  /// Matches all the images with a regex and returns a list of urls
  /// in image_paths, for details see midjourney example json file.
  List<String> extractImageUrls(String reponse) {
    final json = RegExp(
      r'<script id="__NEXT_DATA__" type="application/json">\s*({.*})\s*</script>',
      multiLine: true,
      dotAll: true,
    ).firstMatch(reponse)!.group(1)!;
    final data = jsonDecode(json) as Map<String, dynamic>;
    final props = data['props'] as Map<String, dynamic>;
    final pageProps = props['pageProps'] as Map<String, dynamic>;
    final jobs = pageProps['jobs'] as List<dynamic>;
    final urls = <String>[];
    for (final job in jobs) {
      // ignore: avoid_dynamic_calls
      final images = job['image_paths'] as List<dynamic>;
      for (final imagePath in images) {
        urls.add(imagePath as String);
      }
    }

    return urls;
  }

  /// Fetches recent images
  /// Default images are used if the API is unavailable
  Future<List<String>> fetchRecent() async {
    final imgs = (await _getImages(url: recentUrl)).toList();

    return imgs.isEmpty ? Default().recent : imgs;
  }

  /// Fetches top images
  /// Default images are used if the API is unavailable
  Future<List<String>> fetchTop() async {
    final imgs = (await _getImages(url: topUrl)).toList();
    return imgs.isEmpty ? Default().top : imgs;
  }
}

/// Sometimes Midjouney will be unavailable,
/// so we need a default links for each category
class Default {
  List<String> recent = [
    'https://cdn.midjourney.com/0052fa0b-2954-4971-bd1e-3cc542639ea1/0_1.png',
    'https://cdn.midjourney.com/01991491-e447-4247-a4cd-3c18f70c196f/0_2.png',
    'https://cdn.midjourney.com/01d3ef47-b213-44fc-a415-0c8e76b27115/0_0.png',
    'https://cdn.midjourney.com/0299f839-2380-4a1d-85b3-d2af257c67ac/0_3.png',
    'https://cdn.midjourney.com/0299f839-2380-4a1d-85b3-d2af257c67ac/0_3.png',
    'https://cdn.midjourney.com/029c63bc-e8a6-409d-b1b5-277eed62730e/0_1.png',
    'https://cdn.midjourney.com/02d68409-aa61-49ba-96f3-1f2e5c8eea87/0_3.png',
    'https://cdn.midjourney.com/032e0db3-86c6-4c80-a2ba-d23b9231cccc/0_0.png',
    'https://cdn.midjourney.com/03cf2eeb-5e25-412a-b9ed-537c34aace3b/0_1.png',
    'https://cdn.midjourney.com/03cf96c2-8641-4bbb-b708-eb572ea0a5a4/0_3.png',
    'https://cdn.midjourney.com/042e892c-9ef6-4902-ad8b-e4ddfad76be9/0_1.png',
    'https://cdn.midjourney.com/04468b35-23fe-4f79-bdfa-9b34d427496a/0_0.png',
    'https://cdn.midjourney.com/0482e4ab-60c2-493c-b9e9-a900fd1d9d5a/0_0.png',
    'https://cdn.midjourney.com/04a1935c-45b6-4cb1-adbf-57c305f84d27/0_0.png',
    'https://cdn.midjourney.com/05042f82-98c8-4665-b807-32677226a7bb/0_2.png',
    'https://cdn.midjourney.com/05042f82-98c8-4665-b807-32677226a7bb/0_2.png',
    'https://cdn.midjourney.com/054271d3-dc5c-4c81-86bf-c61fe16f7957/0_3.png',
    'https://cdn.midjourney.com/062dda19-aada-45e1-ba6c-173bcbc5c1d8/0_2.png',
    'https://cdn.midjourney.com/062dda19-aada-45e1-ba6c-173bcbc5c1d8/0_2.png',
    'https://cdn.midjourney.com/065a10d4-2fad-4c1c-bfe0-54109694ce9b/0_0.png',
    'https://cdn.midjourney.com/068efa9d-9cd0-4f13-8084-278b50abfec1/0_0.png',
    'https://cdn.midjourney.com/068efa9d-9cd0-4f13-8084-278b50abfec1/0_0.png',
    'https://cdn.midjourney.com/0052fa0b-2954-4971-bd1e-3cc542639ea1/0_1.png',
  ];

  final List<String> top = [
    'https://cdn.midjourney.com/095a1346-981d-4278-b67c-899374797d67/0_1.png',
    'https://cdn.midjourney.com/036779b7-3d10-4baf-a5ae-5f6982302c68/0_3.png',
    'https://cdn.midjourney.com/06eb9ee9-3980-4f3c-aa0d-41db22e08b62/0_0.png',
    'https://cdn.midjourney.com/082d41ae-2356-4a49-bb73-28da9dfec671/0_2.png',
    'https://cdn.midjourney.com/093eac0c-53be-4670-8e5e-2dbff4ff73b2/0_2.png',
    'https://cdn.midjourney.com/095a1346-981d-4278-b67c-899374797d67/0_1.png',
    'https://cdn.midjourney.com/0a8e7cc9-99cf-4aff-a0e2-cc73321f47dd/0_1.png',
    'https://cdn.midjourney.com/0b4be66a-4a72-4858-86d2-1a7a380e7448/0_0.png',
    'https://cdn.midjourney.com/0e189e29-93fb-4c4d-90cf-03be9cea58b8/0_2.png',
    'https://cdn.midjourney.com/0f78c661-e32a-42b6-b088-1da08819491a/0_2.png',
    'https://cdn.midjourney.com/119ee63b-9cf0-4486-be32-428d265e3807/0_0.png',
    'https://cdn.midjourney.com/11e79ac3-19ec-4c4f-a0d4-20c94d33bd15/0_1.png',
    'https://cdn.midjourney.com/12412704-77cc-4267-b85e-b4f9c5888921/0_2.png',
    'https://cdn.midjourney.com/12c73549-1695-4d42-aa08-e4b37571a698/0_0.png',
    'https://cdn.midjourney.com/17e6340c-5e0d-4f87-abda-7391370e4446/0_2.png',
    'https://cdn.midjourney.com/1940a284-526e-4e2e-9ac8-896db56a8849/0_0.png',
    'https://cdn.midjourney.com/1cd7313d-b324-4582-a9ad-e3d8dc24abd8/0_2.png',
    'https://cdn.midjourney.com/1eb6f1fc-a385-47df-8fa7-d542aa555957/0_1.png',
    'https://cdn.midjourney.com/218bf629-ad38-4819-b271-a0c0a7470f68/0_0.png',
    'https://cdn.midjourney.com/22a0013b-8d05-4c09-8b2b-1eb9b11b642d/0_2.png',
    'https://cdn.midjourney.com/23306631-6b76-40a3-96a0-bce23aeda187/0_3.png',
    'https://cdn.midjourney.com/23bc2edd-4088-4eb0-b374-39d8fe1505d6/0_1.png',
    'https://cdn.midjourney.com/036779b7-3d10-4baf-a5ae-5f6982302c68/0_3.png',
  ];
}
