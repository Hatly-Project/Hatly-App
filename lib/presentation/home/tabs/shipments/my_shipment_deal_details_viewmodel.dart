import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/accept_shipment_deal_response_dto.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/accept_shipment_deal_usecase.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_my_shipment_deal_details_usecase.dart';
import 'package:hatly/domain/usecase/get_user_shipments_usecase.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class GetMyShipmentDealDetailsViewModel
    extends Cubit<MyShipmentDealDetailsViewState> {
  late ApiManager apiManager;
  late ShipmentRepository shipmentRepository;
  late ShipmentDataSource shipmentDataSource;
  late GetMyShipmentDealDetailsUsecase usecase;
  late AcceptShipmentDealUsecase acceptShipmentDealUsecase;

  GetMyShipmentDealDetailsViewModel()
      : super(MyShipmentDealDetailsInitialState()) {
    apiManager = ApiManager();
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    usecase = GetMyShipmentDealDetailsUsecase(repository: shipmentRepository);
    acceptShipmentDealUsecase = AcceptShipmentDealUsecase(shipmentRepository);
  }

  Future<void> getMyShipmentDealDetails(
      {required String dealId, required String token}) async {
    emit(GetMyShipmentDealDetailsLoadingState('Loading...'));

    try {
      var response =
          await usecase.getMyShipmentDealDetails(token: token, dealId: dealId);
      // createUserInDb(user);
      emit(GetMyShipmentDealDetailsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetMyShipmentDealDetailsFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(GetMyShipmentDealDetailsFailState(e.toString()));
    }
  }

  Future<void> acceptShipmentDeal(
      {required String dealId,
      required String status,
      required String token}) async {
    emit(AcceptShipmentDealLoadingState('Loading...'));

    try {
      var response = await acceptShipmentDealUsecase.acceptShipmentDeal(
          token: token, dealId: dealId, status: status);
      // createUserInDb(user);
      emit(AcceptShipmentDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(AcceptShipmentDealFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(AcceptShipmentDealFailState(e.toString()));
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
  AcceptShipmentDealResponseDto responseDto;

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
