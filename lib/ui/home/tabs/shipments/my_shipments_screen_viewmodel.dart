import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_user_shipments_usecase.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class MyShipmentsScreenViewModel extends Cubit<ShipmentViewState> {
  late ApiManager apiManager;
  late ShipmentRepository shipmentRepository;
  late ShipmentDataSource shipmentDataSource;
  late CreateShipmentUsecase createShipmentUsecase;
  late GetUserShipmentUsecase userShipmentUsecase;

  MyShipmentsScreenViewModel() : super(ShipmentInitialState()) {
    apiManager = ApiManager();
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    createShipmentUsecase = CreateShipmentUsecase(shipmentRepository);
    userShipmentUsecase = GetUserShipmentUsecase(shipmentRepository);
  }

  void create(
      {String? title,
      double? weight,
      String? from,
      String? note,
      String? to,
      String? date,
      double? reward,
      List<ItemDto>? items,
      required String token}) async {
    emit(CreateShipLoadingState('Loading...'));

    try {
      print('notessss $note');
      var response = await createShipmentUsecase.invoke(
          token: token,
          title: title,
          reward: reward,
          from: from,
          to: to,
          note: note,
          date: date,
          items: items);
      // createUserInDb(user);
      emit(CreateShipSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(CreateShipFailState(e.errorMessage));
    }
  }

  Future<void> getMyShipments({required String token}) async {
    emit(GetMyShipmentsLoadingState('Loading... '));

    try {
      var response = await userShipmentUsecase.invoke(token: token);
      print('gettttttt');

      emit(GetMyShipmentsSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(GetMyShipmentsFailState(e.errorMessage));
    }
  }
}

abstract class ShipmentViewState {}

class ShipmentInitialState extends ShipmentViewState {}

class CreateShipSuccessState extends ShipmentViewState {
  CreateShipmentsResponseDto responseDto;

  CreateShipSuccessState(this.responseDto);
}

class GetMyShipmentsSuccessState extends ShipmentViewState {
  GetUserShipmentsDto responseDto;

  GetMyShipmentsSuccessState(this.responseDto);
}

class GetMyShipmentsLoadingState extends ShipmentViewState {
  String loadingMessage;

  GetMyShipmentsLoadingState(this.loadingMessage);
}

class GetMyShipmentsFailState extends ShipmentViewState {
  String failMessage;

  GetMyShipmentsFailState(this.failMessage);
}

class CreateShipLoadingState extends ShipmentViewState {
  String loadingMessage;

  CreateShipLoadingState(this.loadingMessage);
}

class CreateShipFailState extends ShipmentViewState {
  String failMessage;

  CreateShipFailState(this.failMessage);
}
