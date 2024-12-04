import 'package:dio/dio.dart';
import 'package:flutter_movie_booking_app/models/genres.dart';
import 'package:flutter_movie_booking_app/models/movie_detail.dart';
import '../models/movie.dart';

class MovieService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YTUzMDI4Nzg2NGVmNGJhMmZiZjYzYWJmYjZiMmVhNCIsIm5iZiI6MTczMzEzMTU0Mi44MTIsInN1YiI6IjY3NGQ3ZDE2YmMxOTFmNmZmNTYxZDAxNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uMJLRk5U8a4XW3kCknJIVoiPP-O3WbGToiNEbGNPlt4',
        'Content-Type': 'application/json;charset=utf-8',
      },
    ),
  );

  Future<List<Movie>> fetchPopularMovies(int page) async {
    try {
      final response = await _dio.get('/movie/popular', queryParameters: {
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

  Future<List<Movie>> fetchNowPlayingMovies() async {
    try {
      final response = await _dio.get('/movie/now_playing', queryParameters: {
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

  Future<List<Movie>> fetchRecommendedMovies(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/recommendations',
        queryParameters: {
          'language': 'en-US',
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
        '/movie/$movieId',
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

  Future<List<Genres>> fetchGenres() async {
    try {
      final response = await _dio.get(
        '/genre/movie/list?language=en',
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
        '/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc',
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
