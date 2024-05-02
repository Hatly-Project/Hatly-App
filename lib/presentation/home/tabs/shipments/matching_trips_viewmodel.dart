import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/cancel_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/accept_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/cancel_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/counter_offer_usecase.dart';
import 'package:hatly/domain/usecase/get_my_shipment_deal_details_usecase.dart';
import 'package:hatly/domain/usecase/get_shipment_matching_trips_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';
import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';

class ShipmentMatchingTripsViewmodel
    extends Cubit<GetShipmentMatchingTripsViewState> {
  late ApiManager _apiManager;
  late ShipmentRepository _shipmentRepository;
  late ShipmentDataSource _shipmentDataSource;
  late GetShipmentMatchingTripsUsecase _usecase;
  AccessTokenProvider accessTokenProvider;
  ShipmentMatchingTripsViewmodel(this.accessTokenProvider)
      : super(MyShipmentDealDetailsInitialState()) {
    _apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    _shipmentDataSource = ShipmentDataSourceImpl(_apiManager);
    _shipmentRepository = ShipmentRepositoryImpl(_shipmentDataSource);
    _usecase = GetShipmentMatchingTripsUsecase(repository: _shipmentRepository);
  }

  Future<void> getShipmentMatchingTrips(
      {required int shipmentId, required String token}) async {
    emit(GetShipmentMatchingTripsLoadingState('Loading...'));

    try {
      var response = await _usecase.getShipmentMatchingTrips(
          token: token, shipmentId: shipmentId);
      // createUserInDb(user);
      emit(GetShipmentMatchingTripsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetShipmentMatchingTripsFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(GetShipmentMatchingTripsFailState(e.toString()));
    }
  }
}

abstract class GetShipmentMatchingTripsViewState {}

class MyShipmentDealDetailsInitialState
    extends GetShipmentMatchingTripsViewState {}

class GetShipmentMatchingTripsSuccessState
    extends GetShipmentMatchingTripsViewState {
  ShipmentMatchingTripsResponseDto responseDto;

  GetShipmentMatchingTripsSuccessState(this.responseDto);
}

class GetShipmentMatchingTripsLoadingState
    extends GetShipmentMatchingTripsViewState {
  String loadingMessage;

  GetShipmentMatchingTripsLoadingState(this.loadingMessage);
}

class GetShipmentMatchingTripsFailState
    extends GetShipmentMatchingTripsViewState {
  String failMessage;

  GetShipmentMatchingTripsFailState(this.failMessage);
}
