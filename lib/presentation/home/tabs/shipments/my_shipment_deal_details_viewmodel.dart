import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_shipment_deal_details_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
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

  GetMyShipmentDealDetailsViewModel()
      : super(MyShipmentDealDetailsInitialState()) {
    apiManager = ApiManager();
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    usecase = GetMyShipmentDealDetailsUsecase(repository: shipmentRepository);
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
