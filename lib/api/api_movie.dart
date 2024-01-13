import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/Models/movie_modal.dart';
import 'package:movie_app/constants/key.dart';

class Api {
  static String _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${apikey}';
  static String _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${apikey}';
  static String _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${apikey}';

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upcomingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }
}
