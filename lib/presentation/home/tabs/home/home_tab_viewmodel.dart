import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_all_shipments_usecase.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class HomeScreenViewModel extends Cubit<HomeViewState> {
  late ApiManager apiManager;
  late ShipmentRepository shipmentRepository;
  late ShipmentDataSource shipmentDataSource;
  late GetAllShipmentsUsecase getAllShipmentsUsecase;
  late TripsRepository tripsRepository;
  late TripsDatasource tripsDatasource;
  late GetAllTripsUsecase getAllTripsUsecase;
  List<ShipmentDto> shipments = [];
  List<TripsDto> trips = [];

  bool hasShipmentsReachedMax = false, hasTripsReachedMax = false;
  int shipmentsPage = 1, tripsPage = 1;

  HomeScreenViewModel() : super(GetAllShipmentsInitialState()) {
    apiManager = ApiManager();
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    getAllShipmentsUsecase = GetAllShipmentsUsecase(shipmentRepository);
    tripsDatasource = TripsDatasourceImpl(apiManager);
    tripsRepository = TripsRepositoryImpl(tripsDatasource);
    getAllTripsUsecase = GetAllTripsUsecase(tripsRepository);
  }

  Future<void> create(String token,
      {bool isPagination = false, isRefresh = false}) async {
    if (!isPagination) {
      emit(GetAllShipsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        var response = await getAllShipmentsUsecase.invoke(
            token: token, page: shipmentsPage);
        shipments = response.shipments!;
        hasShipmentsReachedMax = response.shipments!.isEmpty;
      } else {
        if (isRefresh) {
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(token: token);
          shipments = response.shipments!;
          hasShipmentsReachedMax = response.shipments!.isEmpty;
        } else {
          var response = await getAllShipmentsUsecase.invoke(token: token);
          shipments = response.shipments!;
          hasShipmentsReachedMax = response.shipments!.isEmpty;
        }
      }
      shipmentsPage++;
      print('page $shipmentsPage');
      // for (var shipment in response.shipments!) {
      //   shipments.add(shipment);
      // }

      // createUserInDb(user);
      emit(GetAllShipsSuccessState(
          shipmentDto: shipments,
          hasReachedMax: hasShipmentsReachedMax,
          currentPage: shipmentsPage));
    } on ServerErrorException catch (e) {
      emit(GetAllShipsFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(GetAllShipsFailState(e.toString()));
    }
  }

  Future<void> getAlltrips(String token,
      {bool isPagination = false, isRefresh = false}) async {
    if (!isPagination) {
      emit(GetAllTripsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        var response =
            await getAllTripsUsecase.invoke(token: token, page: tripsPage);
        trips = response.trips!;
        hasShipmentsReachedMax = response.trips!.isEmpty;
      } else {
        if (isRefresh) {
          tripsPage = 1;
          var response = await getAllTripsUsecase.invoke(token: token);
          trips = response.trips!;
          hasTripsReachedMax = response.trips!.isEmpty;
        } else {
          var response = await getAllTripsUsecase.invoke(token: token);
          trips = response.trips!;
          hasTripsReachedMax = response.trips!.isEmpty;
        }
      }
      tripsPage++;
      print('page $tripsPage');
      // for (var shipment in response.shipments!) {
      //   shipments.add(shipment);
      // }

      // createUserInDb(user);
      emit(GetAllTripsSuccessState(
          tripsDto: trips,
          hasReachedMax: hasTripsReachedMax,
          currentPage: tripsPage));
    } on ServerErrorException catch (e) {
      emit(GetAllTripsFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(GetAllTripsFailState(e.toString()));
    }
  }
}

abstract class HomeViewState {}

class GetAllShipmentsInitialState extends HomeViewState {}

class GetAllShipsSuccessState extends HomeViewState {
  List<ShipmentDto> shipmentDto;
  bool hasReachedMax;
  int currentPage;

  GetAllShipsSuccessState(
      {required this.hasReachedMax,
      required this.shipmentDto,
      required this.currentPage});
}

class GetAllShipsLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllShipsLoadingState(this.loadingMessage);
}

class GetAllShipsPaginationLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllShipsPaginationLoadingState(this.loadingMessage);
}

class GetAllShipsFailState extends HomeViewState {
  String failMessage;

  GetAllShipsFailState(this.failMessage);
}

class GetAllTripsSuccessState extends HomeViewState {
  List<TripsDto> tripsDto;
  bool hasReachedMax;
  int currentPage;

  GetAllTripsSuccessState(
      {required this.currentPage,
      required this.hasReachedMax,
      required this.tripsDto});
}

class GetAllTripsLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllTripsLoadingState(this.loadingMessage);
}

class GetAllTripsFailState extends HomeViewState {
  String failMessage;

  GetAllTripsFailState(this.failMessage);
}
