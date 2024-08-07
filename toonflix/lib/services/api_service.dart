import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');

    //this will be the final data from the API
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //it means the request is successful
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(instance);
        // var title = webtoon.title;
        // var id = webtoon.id;
        // print('id: $id, title: $title');
      }

      return webtoonInstances; //여기서 함수를 끝낸다.
    }
    throw Error(); //만약 if 부분이 실행되지않으면 에러를 발생시킨다.
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);

    List<WebtoonEpisodeModel> episodeInstances = [];

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        var episodeModel = WebtoonEpisodeModel.fromJson(episode);
        episodeInstances.add(episodeModel);
      }
      return episodeInstances;
    }
    throw Error();
  }
}
