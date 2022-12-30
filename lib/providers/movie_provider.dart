import 'package:app_peliculas/models/models.dart';
import 'package:app_peliculas/models/search_response.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '8319e93b88e49296asdfsdfsdf7s8df7s8d7f852a';
  String _lenguaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayPopular = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;
  MoviesProvider() {
    print('Movies provider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }
  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
    var url = Uri.https(this._baseUrl, endPoint,
        {'api_key': this._apiKey, 'language': this._lenguaje, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    print(_popularPage);
    final jsonData = await this._getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    onDisplayPopular = [...onDisplayPopular, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    print('pidiendo info al servidor');
    final jsonData = await this._getJsonData('/3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(this._baseUrl, '3/search/movie', {
      'api_key': this._apiKey,
      'language': this._lenguaje,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }
}
