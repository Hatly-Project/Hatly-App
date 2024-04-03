import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:hatly/providers/access_token_provider.dart';

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
  AccessTokenProvider accessTokenProvider;
  List<ShipmentDto> shipments = [];
  List<TripsDto> trips = [];

  bool hasShipmentsReachedMax = false, hasTripsReachedMax = false;
  int shipmentsPage = 1, tripsPage = 1;
  int? totalShipmentPages, totalTripsPages;

  HomeScreenViewModel(this.accessTokenProvider)
      : super(GetAllShipmentsInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
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
        emit(GetAllShipsPaginationLoadingState('Loading...'));

        var response = await getAllShipmentsUsecase.invoke(
            token: token, page: shipmentsPage);
        shipments = response.shipments!;
        totalShipmentPages = response.totalPages;
        print('total pages $totalShipmentPages');

        print('pagination length ${shipments.length}');
        hasShipmentsReachedMax = response.shipments!.isEmpty;
      } else {
        if (isRefresh) {
          print('api refresh');
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(token: token);
          shipments = response.shipments!;
          totalShipmentPages = response.totalPages;
          print('total pages $totalShipmentPages');
          hasShipmentsReachedMax = response.shipments!.isEmpty;
        } else {
          print('api normal');
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(token: token);
          shipments = response.shipments!;
          hasShipmentsReachedMax = response.shipments!.isEmpty;
          totalShipmentPages = response.totalPages;
          print('total pages $totalShipmentPages');
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
          totalPages: totalShipmentPages!,
          hasReachedMax: hasShipmentsReachedMax,
          currentPage: shipmentsPage));
    } on ServerErrorException catch (e) {
      emit(GetAllShipsFailState(e.errorMessage, statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(GetAllShipsFailState(e.toString()));
    }
  }

  Future<void> refreshAccessToken() async {
    // emit(GetAllShipsLoadingState('Loading...'));

    try {
      String newAccessToken = await apiManager.refreshAccessToken();
      await const FlutterSecureStorage()
          .write(key: 'accessToken', value: newAccessToken);
      print('new tokennnnnnnnn $newAccessToken');
      await create(newAccessToken);
    } on ServerErrorException catch (e) {
      emit(RefreshTokenFailState(e.errorMessage));
    } on Exception catch (e) {
      emit(RefreshTokenFailState(e.toString()));
    }
  }

  Future<void> getAlltrips(String token,
      {bool isPagination = false, isRefresh = false}) async {
    if (!isPagination) {
      emit(GetAllTripsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        emit(GetAllTripsPaginationLoadingState('Loading...'));
        var response =
            await getAllTripsUsecase.invoke(token: token, page: tripsPage);
        trips = response.trips!;
        totalTripsPages = response.totalPages;
        hasShipmentsReachedMax = response.trips!.isEmpty;
      } else {
        if (isRefresh) {
          tripsPage = 1;
          var response = await getAllTripsUsecase.invoke(token: token);
          trips = response.trips!;
          totalTripsPages = response.totalPages;

          hasTripsReachedMax = response.trips!.isEmpty;
        } else {
          var response = await getAllTripsUsecase.invoke(token: token);
          trips = response.trips!;
          totalTripsPages = response.totalPages;
          tripsPage = 1;
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
          totalPages: totalTripsPages!,
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
  int currentPage, totalPages;

  GetAllShipsSuccessState(
      {required this.hasReachedMax,
      required this.totalPages,
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
  int? statusCode;
  GetAllShipsFailState(this.failMessage, {this.statusCode});
}

class GetAllTripsSuccessState extends HomeViewState {
  List<TripsDto> tripsDto;
  bool hasReachedMax;
  int currentPage, totalPages;

  GetAllTripsSuccessState(
      {required this.currentPage,
      required this.totalPages,
      required this.hasReachedMax,
      required this.tripsDto});
}

class GetAllTripsLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllTripsLoadingState(this.loadingMessage);
}

class GetAllTripsPaginationLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllTripsPaginationLoadingState(this.loadingMessage);
}

class GetAllTripsFailState extends HomeViewState {
  String failMessage;

  GetAllTripsFailState(this.failMessage);
}

class RefreshTokenSuccessState extends HomeViewState {
  String newAccessToken;

  RefreshTokenSuccessState({required this.newAccessToken});
}

class RefreshTokenFailState extends HomeViewState {
  String failMessage;

  RefreshTokenFailState(this.failMessage);
}
