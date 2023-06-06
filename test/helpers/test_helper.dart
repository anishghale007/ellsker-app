import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internship_practice/core/network/network_info.dart';
import 'package:internship_practice/features/call/data/datasources/call_remote_data_source.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  CallRepository,
  CallRemoteDataSource,
  GetRtcTokenUsecase,
  InternetConnectionChecker,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
