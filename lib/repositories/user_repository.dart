import 'package:dio/dio.dart';
import 'package:flutter_retrofit_example/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

@RestApi(baseUrl: 'https://5f7cba02834b5c0016b058aa.mockapi.io/api/')
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/users')
  Future<List<UserModel>> findAll();

  @GET('/users/{id}')
  Future<UserModel> findById(@Path('id') String id);

  @POST('/users')
  Future<void> save(@Body() UserModel user);

}
