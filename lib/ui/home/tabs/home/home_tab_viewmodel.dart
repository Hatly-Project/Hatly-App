import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_all_shipments_usecase.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class HomeScreenViewModel extends Cubit<HomeViewState> {
  late ApiManager apiManager;
  late ShipmentRepository shipmentRepository;
  late ShipmentDataSource shipmentDataSource;
  late GetAllShipmentsUsecase getAllShipmentsUsecase;
  HomeScreenViewModel() : super(GetAllShipmentsInitialState()) {
    apiManager = ApiManager();
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    getAllShipmentsUsecase = GetAllShipmentsUsecase(shipmentRepository);
  }

  Future<void> create() async {
    emit(GetAllShipsLoadingState('Loading...'));

    try {
      var response = await getAllShipmentsUsecase.invoke();
      // createUserInDb(user);
      emit(GetAllShipsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetAllShipsFailState(e.errorMessage));
    }
  }
}

abstract class HomeViewState {}

class GetAllShipmentsInitialState extends HomeViewState {}

class GetAllShipsSuccessState extends HomeViewState {
  GetAllShipmentResponseDto responseDto;

  GetAllShipsSuccessState(this.responseDto);
}

class GetAllShipsLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllShipsLoadingState(this.loadingMessage);
}

class GetAllShipsFailState extends HomeViewState {
  String failMessage;

  GetAllShipsFailState(this.failMessage);
}
