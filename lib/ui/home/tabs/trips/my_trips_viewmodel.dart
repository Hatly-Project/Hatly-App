import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/create_trip_usecase.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';

class MyTripsViewmodel extends Cubit<MyTripsViewState> {
  late ApiManager apiManager;
  late TripsRepository repository;
  late TripsDatasource tripsDatasource;
  late CreateTripUsecase createTripUsecase;

  MyTripsViewmodel() : super(MyTripsInitialState()) {
    apiManager = ApiManager();
    tripsDatasource = TripsDatasourceImpl(apiManager);
    repository = TripsRepositoryImpl(tripsDatasource);
    createTripUsecase = CreateTripUsecase(repository);
  }

  void createTrip(
      {String? origin,
      String? destination,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      String? notNeed,
      required String token}) async {
    try {
      emit(CreateTripLoadingState('Loading...'));
      var response = await createTripUsecase.invoke(
          token: token,
          origin: origin,
          destination: destination,
          available: available,
          note: note,
          addressMeeting: addressMeeting,
          departDate: departDate,
          notNeed: notNeed);
      emit(CreateTripSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(CreateTripFailState(e.errorMessage));
    }
  }
}

abstract class MyTripsViewState {}

class MyTripsInitialState extends MyTripsViewState {}

class CreateTripSuccessState extends MyTripsViewState {
  CreateTripResponseDto responseDto;

  CreateTripSuccessState(this.responseDto);
}

class CreateTripFailState extends MyTripsViewState {
  String failMessage;

  CreateTripFailState(this.failMessage);
}

class CreateTripLoadingState extends MyTripsViewState {
  String loadingMessage;

  CreateTripLoadingState(this.loadingMessage);
}
