// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_movie_booking_app/features/movie/data/services/movie_services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_movie_booking_app/features/movie/data/models/movie.dart';
// import 'package:flutter_movie_booking_app/features/movie/data/models/movie_detail.dart';

// // Create Mock classes
// class MockDio extends Mock implements Dio {}

// class MockResponse extends Mock implements Response {}

// void main() {
//   late MovieService movieService;
//   late MockDio mockDio;

//   // Memuat file .env sebelum test
//   setUpAll(() async {
//     await dotenv.load();
//   });

//   setUp(() {
//     mockDio = MockDio();
//     movieService =
//         MovieService(); // Use the constructor of your MovieService class
//     movieService.dio = mockDio; // Override the Dio instance with mockDio
//   });

//   group('MovieService Test', () {
//     test(
//         'should return a list of popular movies when the response is successful',
//         () async {
//       final mockData = {
//         'results': [
//           {'id': 1, 'title': 'Movie 1'},
//           {'id': 2, 'title': 'Movie 2'},
//         ],
//       };

//       // Membuat mock Response
//       final mockResponse = Response(
//         requestOptions: RequestOptions(path: '/3/movie/popular'),
//         data: mockData,
//       );

//       // Mengonfigurasi mockDio untuk mengembalikan mockResponse saat get() dipanggil
//       when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
//           .thenAnswer((_) async => mockResponse);

//       final movies = await movieService.fetchPopularMovies(2);
//       print(movies);

//       expect(movies, isA<List<Movie>>());
//       expect(movies.length, 2);
//       expect(movies[0].title, 'Movie 1');
//     });

//     test('should throw an exception when the response is unsuccessful',
//         () async {
//       final mockResponse = Response(
//         requestOptions: RequestOptions(path: '/3/movie/popular'),
//         statusCode: 500,
//       );

//       // Mengonfigurasi mockDio untuk mengembalikan mockResponse dengan status code 500
//       when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
//           .thenAnswer((_) async => mockResponse);

//       expect(() async => await movieService.fetchPopularMovies(1),
//           throwsException);
//     });

//     test('should return movie details when the response is successful',
//         () async {
//       final mockData = {
//         'id': 1,
//         'title': 'Movie 1',
//         'overview': 'Movie overview',
//       };

//       final mockResponse = Response(
//         requestOptions: RequestOptions(path: '/3/movie/1'),
//         data: mockData,
//       );

//       // Mengonfigurasi mockDio untuk mengembalikan mockResponse saat get() dipanggil
//       when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
//           .thenAnswer((_) async => mockResponse);

//       final movieDetail = await movieService.fetchMovieDetails(1);

//       expect(movieDetail, isA<MovieDetail>());
//       expect(movieDetail.title, 'Movie 1');
//     });

//     test('should throw an exception when fetching movie details fails',
//         () async {
//       final mockResponse = Response(
//         requestOptions: RequestOptions(path: '/3/movie/1'),
//         statusCode: 500,
//       );

//       // Mengonfigurasi mockDio untuk mengembalikan mockResponse dengan status code 500
//       when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
//           .thenAnswer((_) async => mockResponse);

//       expect(
//           () async => await movieService.fetchMovieDetails(1), throwsException);
//     });

//     // You can add more tests for other methods like searchMovies, fetchNowPlayingMovies, etc.
//   });
// }
