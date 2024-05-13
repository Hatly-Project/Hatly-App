import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/accept_reject_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/cancel_deal_response_dto.dart';
import 'package:hatly/domain/models/counter_offer_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/accept_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/cancel_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/counter_offer_usecase.dart';
import 'package:hatly/domain/usecase/get_my_shipment_deal_details_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';
import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';

class GetMyShipmentDealDetailsViewModel
    extends Cubit<MyShipmentDealDetailsViewState> {
  late ApiManager _apiManager;
  late ShipmentRepository _shipmentRepository;
  late ShipmentDataSource _shipmentDataSource;
  late GetMyShipmentDealDetailsUsecase _usecase;
  late AcceptShipmentDealUsecase _acceptShipmentDealUsecase;
  late ShipmentCounterOfferUsecase _shipmentCounterOfferUsecase;
  late CancelShipmentDealUsecae _cancelShipmentDealUsecae;
  AccessTokenProvider accessTokenProvider;
  GetMyShipmentDealDetailsViewModel(this.accessTokenProvider)
      : super(MyShipmentDealDetailsInitialState()) {
    _apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    _shipmentDataSource = ShipmentDataSourceImpl(_apiManager);
    _shipmentRepository = ShipmentRepositoryImpl(_shipmentDataSource);
    _usecase = GetMyShipmentDealDetailsUsecase(repository: _shipmentRepository);
    _acceptShipmentDealUsecase = AcceptShipmentDealUsecase(_shipmentRepository);
    _shipmentCounterOfferUsecase =
        ShipmentCounterOfferUsecase(shipmentRepository: _shipmentRepository);
    _cancelShipmentDealUsecae = CancelShipmentDealUsecae(_shipmentRepository);
  }

  Future<void> getMyShipmentDealDetails(
      {required String dealId, required String token}) async {
    emit(GetMyShipmentDealDetailsLoadingState('Loading...'));

    try {
      var response =
          await _usecase.getMyShipmentDealDetails(token: token, dealId: dealId);
      // createUserInDb(user);
      emit(GetMyShipmentDealDetailsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetMyShipmentDealDetailsFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(GetMyShipmentDealDetailsFailState(e.toString()));
    }
  }

  Future<void> acceptShipmentDeal(
      {required String dealId, required String token}) async {
    emit(AcceptShipmentDealLoadingState('Loading...'));

    try {
      var response = await _acceptShipmentDealUsecase.acceptShipmentDeal(
          token: token,
          dealId: dealId,
          status: 'accepted',
          dealType: 'shipment');
      // createUserInDb(user);
      emit(AcceptShipmentDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(AcceptShipmentDealFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(AcceptShipmentDealFailState(e.toString()));
    }
  }

  Future<void> rejectShipmentDeal(
      {required String dealId, required String token}) async {
    emit(RejectShipmentDealLoadingState('Loading...'));

    try {
      var response = await _acceptShipmentDealUsecase.acceptShipmentDeal(
          token: token,
          dealId: dealId,
          status: 'rejected',
          dealType: 'shipment');
      // createUserInDb(user);
      emit(RejectShipmentDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(RejectShipmentDealFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(RejectShipmentDealFailState(e.toString()));
    }
  }

  Future<void> cancelShipmentDeal(
      {required int dealId, required String token}) async {
    emit(CancelShipmentDealLoadingState('Loading...'));

    try {
      var response =
          await _cancelShipmentDealUsecae.invoke(token: token, dealId: dealId);
      // createUserInDb(user);
      emit(CancelShipmentDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(CancelShipmentDealFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(CancelShipmentDealFailState(e.toString()));
    }
  }

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

abstract class MyShipmentDealDetailsViewState {}

class MyShipmentDealDetailsInitialState
    extends MyShipmentDealDetailsViewState {}

class GetMyShipmentDealDetailsSuccessState
    extends MyShipmentDealDetailsViewState {
  GetMyShipmentDealDetailsResponseDto responseDto;

  GetMyShipmentDealDetailsSuccessState(this.responseDto);
}

class GetMyShipmentDealDetailsLoadingState
    extends MyShipmentDealDetailsViewState {
  String loadingMessage;

  GetMyShipmentDealDetailsLoadingState(this.loadingMessage);
}

class GetMyShipmentDealDetailsFailState extends MyShipmentDealDetailsViewState {
  String failMessage;

  GetMyShipmentDealDetailsFailState(this.failMessage);
}

class AcceptShipmentDealSuccessState extends MyShipmentDealDetailsViewState {
  AcceptOrRejectShipmentDealResponseDto responseDto;

  AcceptShipmentDealSuccessState(this.responseDto);
}

class AcceptShipmentDealLoadingState extends MyShipmentDealDetailsViewState {
  String loadingMessage;

  AcceptShipmentDealLoadingState(this.loadingMessage);
}

class AcceptShipmentDealFailState extends MyShipmentDealDetailsViewState {
  String failMessage;

  AcceptShipmentDealFailState(this.failMessage);
}

class RejectShipmentDealSuccessState extends MyShipmentDealDetailsViewState {
  AcceptOrRejectShipmentDealResponseDto responseDto;

  RejectShipmentDealSuccessState(this.responseDto);
}

class RejectShipmentDealLoadingState extends MyShipmentDealDetailsViewState {
  String loadingMessage;

  RejectShipmentDealLoadingState(this.loadingMessage);
}

class RejectShipmentDealFailState extends MyShipmentDealDetailsViewState {
  String failMessage;

  RejectShipmentDealFailState(this.failMessage);
}

class CounterOfferLoadingState extends MyShipmentDealDetailsViewState {
  String loadingMessage;
  CounterOfferLoadingState(this.loadingMessage);
}

class CounterOfferSuccessState extends MyShipmentDealDetailsViewState {
  CounterOfferResponseDto responseDto;
  CounterOfferSuccessState(this.responseDto);
}

class CounterOfferFailState extends MyShipmentDealDetailsViewState {
  String failMessage;

  CounterOfferFailState(this.failMessage);
}

class CancelShipmentDealLoadingState extends MyShipmentDealDetailsViewState {
  String loadingMessage;
  CancelShipmentDealLoadingState(this.loadingMessage);
}

class CancelShipmentDealSuccessState extends MyShipmentDealDetailsViewState {
  CancelDealResponseDto responseDto;
  CancelShipmentDealSuccessState(this.responseDto);
}

class CancelShipmentDealFailState extends MyShipmentDealDetailsViewState {
  String failMessage;

  CancelShipmentDealFailState(this.failMessage);
}
