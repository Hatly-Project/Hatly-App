import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';

class MyTripsViewmodel extends Cubit<MyTripsViewState> {
  late ApiManager apiManager;
  late TripsRepository repository;
  late TripsDatasource tripsDatasource;
  late GetAllTripsUsecase getAllTripsUsecase;

  MyTripsViewmodel() : super(MyTripsInitialState()) {
    apiManager = ApiManager();
    tripsDatasource = TripsDatasourceImpl(apiManager);
    repository = TripsRepositoryImpl(tripsDatasource);
    getAllTripsUsecase = GetAllTripsUsecase(repository);
  }

  void getMyTrips() {
    try {} on ServerErrorException catch (e) {}
  }
}

abstract class MyTripsViewState {}

class MyTripsInitialState extends MyTripsViewState {}

class MyTripsSuccessState extends MyTripsViewState {}

class MyTripsFailState extends MyTripsViewState {}

class MyTripsLoadingState extends MyTripsViewState {}
