import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/cancel_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_trip_deal_details_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/accept_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/accept_trip_deal_usecase.dart';
import 'package:hatly/domain/usecase/cancel_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/counter_offer_usecase.dart';
import 'package:hatly/domain/usecase/get_my_shipment_deal_details_usecase.dart';
import 'package:hatly/domain/usecase/get_my_trip_deal_details_usecase.dart';
import 'package:hatly/domain/usecase/trip_counter_offer_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';
import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';

class GetMyTripDealDetailsViewModel extends Cubit<MyTripDealDetailsViewState> {
  late ApiManager _apiManager;
  late TripsRepository _tripsRepository;
  late TripsDatasource _tripsDataSource;
  late GetMyTripDealDetailsUsecase _usecase;
  late AcceptTripDealUsecase _acceptTripDealUsecase;
  late TripCounterOfferUsecase _shipmentCounterOfferUsecase;
  AccessTokenProvider accessTokenProvider;
  GetMyTripDealDetailsViewModel(this.accessTokenProvider)
      : super(MyTripDealDetailsInitialState()) {
    _apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    _tripsDataSource = TripsDatasourceImpl(_apiManager);
    _tripsRepository = TripsRepositoryImpl(_tripsDataSource);
    _usecase = GetMyTripDealDetailsUsecase(repository: _tripsRepository);
    _acceptTripDealUsecase = AcceptTripDealUsecase(_tripsRepository);
    _shipmentCounterOfferUsecase =
        TripCounterOfferUsecase(tripsRepository: _tripsRepository);
    // _cancelShipmentDealUsecae = CancelShipmentDealUsecae(_tripsRepository);
  }

  Future<void> getMyTripDealDetails(
      {required int dealId, required String token}) async {
    emit(GetMyTripDealDetailsLoadingState('Loading...'));

    try {
      var response =
          await _usecase.getMyTripDealDetails(token: token, dealId: dealId);
      // createUserInDb(user);
      emit(GetMyTripDealDetailsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetMyTripDealDetailsFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(GetMyTripDealDetailsFailState(e.toString()));
    }
  }

  Future<void> acceptTripDeal(
      {required String dealId, required String token}) async {
    emit(AcceptTripDealLoadingState('Loading...'));

    try {
      var response = await _acceptTripDealUsecase.acceptTripDeal(
          token: token, dealId: dealId, status: 'accepted', dealType: 'trip');
      // createUserInDb(user);
      emit(AcceptTripDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(AcceptTripDealFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(AcceptTripDealFailState(e.toString()));
    }
  }

  Future<void> rejectTripDeal(
      {required String dealId, required String token}) async {
    emit(RejectTripDealLoadingState('Loading...'));

    try {
      var response = await _acceptTripDealUsecase.acceptTripDeal(
          token: token, dealId: dealId, status: 'rejected', dealType: 'trip');
      // createUserInDb(user);
      emit(RejectTripDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(RejectTripDealFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(RejectTripDealFailState(e.toString()));
    }
  }

  // Future<void> cancelTripDeal(
  //     {required int dealId, required String token}) async {
  //   emit(CancelTripDealLoadingState('Loading...'));

  //   try {
  //     var response =
  //         await _cancelShipmentDealUsecae.invoke(token: token, dealId: dealId);
  //     // createUserInDb(user);
  //     emit(CancelTripDealSuccessState(response));
  //   } on ServerErrorException catch (e) {
  //     emit(CancelTripDealFailState(e.errorMessage));
  //   } on Exception catch (e) {
  //     emit(CancelTripDealFailState(e.toString()));
  //   }
  // }

  Future<void> makeCounterOffer(
      {required String token,
      required int dealId,
      required double reward}) async {
    emit(CounterOfferLoadingState('Loading...'));

    try {
      var response = await _shipmentCounterOfferUsecase.invoke(
          token: token, dealId: dealId, reward: reward);
      emit(CounterOfferSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(CounterOfferFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(CounterOfferFailState(e.toString()));
    }
  }
}

abstract class MyTripDealDetailsViewState {}

class MyTripDealDetailsInitialState extends MyTripDealDetailsViewState {}

class GetMyTripDealDetailsSuccessState extends MyTripDealDetailsViewState {
  GetTripDealDetailsResponseDto responseDto;

  GetMyTripDealDetailsSuccessState(this.responseDto);
}

class GetMyTripDealDetailsLoadingState extends MyTripDealDetailsViewState {
  String loadingMessage;

  GetMyTripDealDetailsLoadingState(this.loadingMessage);
}

class GetMyTripDealDetailsFailState extends MyTripDealDetailsViewState {
  String failMessage;

  GetMyTripDealDetailsFailState(this.failMessage);
}

class AcceptTripDealSuccessState extends MyTripDealDetailsViewState {
  AcceptOrRejectShipmentDealResponseDto responseDto;

  AcceptTripDealSuccessState(this.responseDto);
}

class AcceptTripDealLoadingState extends MyTripDealDetailsViewState {
  String loadingMessage;

  AcceptTripDealLoadingState(this.loadingMessage);
}

class AcceptTripDealFailState extends MyTripDealDetailsViewState {
  String failMessage;

  AcceptTripDealFailState(this.failMessage);
}

class RejectTripDealSuccessState extends MyTripDealDetailsViewState {
  AcceptOrRejectShipmentDealResponseDto responseDto;

  RejectTripDealSuccessState(this.responseDto);
}

class RejectTripDealLoadingState extends MyTripDealDetailsViewState {
  String loadingMessage;

  RejectTripDealLoadingState(this.loadingMessage);
}

class RejectTripDealFailState extends MyTripDealDetailsViewState {
  String failMessage;

  RejectTripDealFailState(this.failMessage);
}

class CounterOfferLoadingState extends MyTripDealDetailsViewState {
  String loadingMessage;
  CounterOfferLoadingState(this.loadingMessage);
}

class CounterOfferSuccessState extends MyTripDealDetailsViewState {
  CounterOfferResponseDto responseDto;
  CounterOfferSuccessState(this.responseDto);
}

class CounterOfferFailState extends MyTripDealDetailsViewState {
  String failMessage;

  CounterOfferFailState(this.failMessage);
}

class CancelTripDealLoadingState extends MyTripDealDetailsViewState {
  String loadingMessage;
  CancelTripDealLoadingState(this.loadingMessage);
}

class CancelTripDealSuccessState extends MyTripDealDetailsViewState {
  CancelDealResponseDto responseDto;
  CancelTripDealSuccessState(this.responseDto);
}

class CancelTripDealFailState extends MyTripDealDetailsViewState {
  String failMessage;

  CancelTripDealFailState(this.failMessage);
}
