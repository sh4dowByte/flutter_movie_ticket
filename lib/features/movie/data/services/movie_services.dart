import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/cast.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/genres.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/movie_detail.dart';
import '../models/movie.dart';

class MovieService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['TMDB_API_BASE_URL']!,
      headers: {
        'Authorization': 'Bearer ${dotenv.env['TMDB_ACCESS_TOKEN']}',
        'Content-Type': 'application/json;charset=utf-8',
      },
    ),
  );

  Future<List<Movie>> fetchPopularMovies(int page) async {
    try {
      final response = await _dio.get('/3/movie/popular', queryParameters: {
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        final List movies = response.data['results'];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch popular movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> searchMovies(String keyword, {int page = 1}) async {
    try {
      final response = await _dio.get('/3/search/movie', queryParameters: {
        'language': 'en-US',
        'page': page,
        'query': keyword,
      });

      if (response.statusCode == 200) {
        final List movies = response.data['results'];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch popular movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    try {
      final response = await _dio.get('/3/movie/now_playing', queryParameters: {
        'language': 'en-US',
      });

      if (response.statusCode == 200) {
        final List movies = response.data['results'];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch now playing movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> fetchRecommendedMovies(movieId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/3/movie/$movieId/recommendations',
        queryParameters: {
          'language': 'en-US',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final List movies = response.data['results'];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch recommended movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<MovieDetail> fetchMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/3/movie/$movieId',
        queryParameters: {
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        return MovieDetail.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch recommended movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Cast>> fetchMovieCaster(int movieId) async {
    try {
      final response = await _dio.get(
        '/3/movie/$movieId/credits',
        queryParameters: {
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        final List cast = response.data['cast'];
        return cast.map((movie) => Cast.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch caster');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Genres>> fetchGenres() async {
    try {
      final response = await _dio.get(
        '/3/genre/movie/list?language=en',
        queryParameters: {
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['genres'];
        return data.map((data) => Genres.fromJson(data)).toList();
      } else {
        throw Exception('Failed to fetch recommended movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> fetchDiscover({int page = 1, int genres = 0}) async {
    try {
      final response = await _dio.get(
        '/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc',
        queryParameters: {
          'language': 'en-US',
          'page': page,
          'with_genres': genres == 0 ? '' : genres
        },
      );

      if (response.statusCode == 200) {
        final List movies = response.data['results'];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to fetch recommended movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
