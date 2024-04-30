import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/shipment_deal_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/send_shipment_deal_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

class ShipmentDealViewmodel extends Cubit<ShipmentDealViewState> {
  late ApiManager apiManager;
  late ShipmentDataSource shipmentDataSource;
  late ShipmentRepository shipmentRepository;
  late SendShipmentDealUsecase sendShipmentDealUsecase;
  AccessTokenProvider accessTokenProvider;
  ShipmentDealViewmodel(this.accessTokenProvider)
      : super(ShipmentDealInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    sendShipmentDealUsecase =
        SendShipmentDealUsecase(repository: shipmentRepository);
  }

  void sendShipmentDeal(
      {required int? shipmentId,
      required double? reward,
      required String token,
      required int tripId}) async {
    emit(ShipmentDealLoadingState('Loading... '));

    try {
      var response = await sendShipmentDealUsecase.sendDeal(
          shipmentId: shipmentId, reward: reward, token: token, tripId: tripId);

      emit(ShipmentDealSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(ShipmentDealFailState(e.errorMessage));
    }
  }
}

abstract class ShipmentDealViewState {}

class ShipmentDealInitialState extends ShipmentDealViewState {}

class ShipmentDealLoadingState extends ShipmentDealViewState {
  String loadingMessage;
  ShipmentDealLoadingState(this.loadingMessage);
}

class ShipmentDealFailState extends ShipmentDealViewState {
  String failMessage;
  ShipmentDealFailState(this.failMessage);
}

class ShipmentDealSuccessState extends ShipmentDealViewState {
  ShipmentDealResponseDto responseDto;
  ShipmentDealSuccessState(this.responseDto);
}
