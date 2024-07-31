import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_user_shipments_response_dto.dart';
import 'package:hatly/domain/models/shipment_matching_trips_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_shipment_matching_trips_usecase.dart';
import 'package:hatly/domain/usecase/get_user_shipments_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class MyShipmentsScreenViewModel extends Cubit<ShipmentViewState> {
  late ApiManager apiManager;
  late ShipmentRepository shipmentRepository;
  late ShipmentDataSource shipmentDataSource;
  late CreateShipmentUsecase createShipmentUsecase;
  late GetUserShipmentUsecase userShipmentUsecase;
  AccessTokenProvider accessTokenProvider;
  late GetShipmentMatchingTripsUsecase _usecase;

  // pass the accessTokenProvider object to the constructor
  MyShipmentsScreenViewModel(this.accessTokenProvider)
      : super(ShipmentInitialState()) {
    apiManager = ApiManager(
        accessTokenProvider:
            accessTokenProvider); // pass the accessTokenProvider object
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    createShipmentUsecase = CreateShipmentUsecase(shipmentRepository);
    userShipmentUsecase = GetUserShipmentUsecase(shipmentRepository);
    _usecase = GetShipmentMatchingTripsUsecase(repository: shipmentRepository);
  }

  // Future<void> getShipmentMatchingTrips(
  //     {required int shipmentId, required String token}) async {
  //   emit(GetMyShipmentMatchingTripsLoadingState('Loading...'));

  //   try {
  //     var response = await _usecase.getShipmentMatchingTrips(
  //         token: token, shipmentId: shipmentId);
  //     // createUserInDb(user);
  //     emit(GetMyShipmentMatchingTripsSuccessState(response));
  //   } on ServerErrorException catch (e) {
  //     emit(GetMyShipmentMatchingTripsFailState(e.errorMessage));
  //   } on Exception catch (e) {
  //     emit(GetMyShipmentMatchingTripsFailState(e.toString()));
  //   }
  // }

  void create(
      {String? title,
      double? weight,
      String? from,
      String? fromCity,
      String? toCity,
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
          fromCity: fromCity,
          toCity: toCity,
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

class GetMyShipmentMatchingTripsSuccessState extends ShipmentViewState {
  ShipmentMatchingTripsResponseDto responseDto;

  GetMyShipmentMatchingTripsSuccessState(this.responseDto);
}

class GetMyShipmentMatchingTripsLoadingState extends ShipmentViewState {
  String loadingMessage;

  GetMyShipmentMatchingTripsLoadingState(this.loadingMessage);
}

class GetMyShipmentMatchingTripsFailState extends ShipmentViewState {
  String failMessage;

  GetMyShipmentMatchingTripsFailState(this.failMessage);
}

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
