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
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trip_deal_response.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/create_trip_usecase.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';
import 'package:hatly/domain/usecase/get_user_trip_usecase.dart';
import 'package:hatly/domain/usecase/send_trip_deal_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

class TripDealViewModel extends Cubit<TripDealViewState> {
  late ApiManager apiManager;
  late TripsRepository repository;
  late TripsDatasource tripsDatasource;
  late SendTripDealUsecase sendTripDealUsecase;
  AccessTokenProvider accessTokenProvider;
  TripDealViewModel(this.accessTokenProvider) : super(TripDealInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    tripsDatasource = TripsDatasourceImpl(apiManager);
    repository = TripsRepositoryImpl(tripsDatasource);
    sendTripDealUsecase = SendTripDealUsecase(repository: repository);
  }

  void sendDealOnShipment(
      {int? shipmentId,
      double? reward,
      required String token,
      required int tripId}) async {
    try {
      emit(CreateTripDealLoadingState('Loading...'));
      var response = await sendTripDealUsecase.sendDeal(
          token: token, tripId: tripId, shipmentId: shipmentId, reward: reward);
      emit(CreateTripDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(CreateTripDealFailState(e.errorMessage));
    }
  }
}

abstract class TripDealViewState {}

class TripDealInitialState extends TripDealViewState {}

class CreateTripDealSuccessState extends TripDealViewState {
  ShipmentDealResponseDto responseDto;

  CreateTripDealSuccessState(this.responseDto);
}

class CreateTripDealFailState extends TripDealViewState {
  String failMessage;

  CreateTripDealFailState(this.failMessage);
}

class CreateTripDealLoadingState extends TripDealViewState {
  String loadingMessage;

  CreateTripDealLoadingState(this.loadingMessage);
}
