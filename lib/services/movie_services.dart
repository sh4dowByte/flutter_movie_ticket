import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  final String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YTUzMDI4Nzg2NGVmNGJhMmZiZjYzYWJmYjZiMmVhNCIsIm5iZiI6MTczMzEzMTU0Mi44MTIsInN1YiI6IjY3NGQ3ZDE2YmMxOTFmNmZmNTYxZDAxNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uMJLRk5U8a4XW3kCknJIVoiPP-O3WbGToiNEbGNPlt4';

  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?language=en-US');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    final url = Uri.parse('$baseUrl/movie/now_playing?language=en-US');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to fetch now playing movies');
    }
  }

  Future<List<Movie>> fetchRecommendedMovies(int movieId) async {
    final url =
        Uri.parse('$baseUrl/movie/$movieId/recommendations?language=en-US');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to fetch recommended movies');
    }
  }
}
