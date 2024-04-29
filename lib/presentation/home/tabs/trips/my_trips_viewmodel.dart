import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/api/items_not_allowed.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/book_info_dto.dart';
import 'package:hatly/domain/models/create_trip_response_dto.dart';
import 'package:hatly/domain/models/get_user_trip_response_dto.dart';
import 'package:hatly/domain/models/items_not_allowed_dto.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/create_trip_usecase.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';
import 'package:hatly/domain/usecase/get_user_trip_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

class MyTripsViewmodel extends Cubit<MyTripsViewState> {
  late ApiManager apiManager;
  late TripsRepository repository;
  late TripsDatasource tripsDatasource;
  late CreateTripUsecase createTripUsecase;
  late GetUserTripUsecase getUserTripUsecase;
  AccessTokenProvider accessTokenProvider;

  MyTripsViewmodel(this.accessTokenProvider) : super(MyTripsInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    tripsDatasource = TripsDatasourceImpl(apiManager);
    repository = TripsRepositoryImpl(tripsDatasource);
    createTripUsecase = CreateTripUsecase(repository);
    getUserTripUsecase = GetUserTripUsecase(repository);
  }

  void createTrip(
      {String? origin,
      String? destination,
      String? originCity,
      String? destinationCity,
      int? available,
      String? note,
      String? addressMeeting,
      String? departDate,
      BookInfoDto? bookInfoDto,
      List<ItemsNotAllowedDto>? itemsNotAllowed,
      required String token}) async {
    try {
      emit(CreateTripLoadingState('Loading...'));
      var response = await createTripUsecase.invoke(
        token: token,
        origin: origin,
        destination: destination,
        originCity: originCity,
        destinationCity: destinationCity,
        available: available,
        bookInfoDto: bookInfoDto,
        itemsNotAllowed: itemsNotAllowed,
        note: note,
        addressMeeting: addressMeeting,
        departDate: departDate,
      );
      emit(CreateTripSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(CreateTripFailState(e.errorMessage));
    }
  }

  void getMyTrip({required String token}) async {
    emit(GetMyTripsLoadingState('Loading...'));

    try {
      var response = await getUserTripUsecase.getUserTrip(token: token);
      emit(GetMyTripsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetMyTripsFailState(e.errorMessage));
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

class GetMyTripsSuccessState extends MyTripsViewState {
  GetUserTripResponseDto responseDto;

  GetMyTripsSuccessState(this.responseDto);
}

class GetMyTripsFailState extends MyTripsViewState {
  String failMessage;

  GetMyTripsFailState(this.failMessage);
}

class GetMyTripsLoadingState extends MyTripsViewState {
  String loadingMessage;

  GetMyTripsLoadingState(this.loadingMessage);
}
