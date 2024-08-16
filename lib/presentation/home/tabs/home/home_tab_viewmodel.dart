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
  int? totalShipmentPages, totalTripsPages, totalShipmentsData, totalTripsData;

  HomeScreenViewModel(this.accessTokenProvider) : super(GetAllInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    getAllShipmentsUsecase = GetAllShipmentsUsecase(shipmentRepository);
    tripsDatasource = TripsDatasourceImpl(apiManager);
    tripsRepository = TripsRepositoryImpl(tripsDatasource);
    getAllTripsUsecase = GetAllTripsUsecase(tripsRepository);
  }

  Future<void> getAllShipments({
    required String? token,
    bool isPagination = false,
    isRefresh = false,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    String? toCity,
    bool? latest,
  }) async {
    if (!isPagination) {
      emit(GetAllShipsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        // emit(GetAllShipsPaginationLoadingState('Loading...'));

        var response = await getAllShipmentsUsecase.invoke(
          token: token!,
          page: shipmentsPage,
          beforeExpectedDate: beforeExpectedDate,
          afterExpectedDate: afterExpectedDate,
          from: from,
          fromCity: fromCity,
          to: to,
          toCity: toCity,
          latest: latest,
        );
        totalShipmentPages = response.totalPages;
        print('total pages $totalShipmentPages');

        print('pagination length ${shipments.length}');
        hasShipmentsReachedMax = response.shipments!.isEmpty;
        totalShipmentsData = response.totalData;

        for (var shipment in response.shipments!) {
          shipments.add(shipment);
        }
      } else {
        if (isRefresh) {
          print('api refresh');
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(
            token: token!,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          shipments = response.shipments!;
          totalShipmentPages = response.totalPages;
          print('total pages $totalShipmentPages');
          hasShipmentsReachedMax = response.shipments!.isEmpty;
          totalShipmentsData = response.totalData;
        } else {
          print('api normal');
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(
            token: token!,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          shipments = response.shipments!;
          hasShipmentsReachedMax = response.shipments!.isEmpty;
          totalShipmentPages = response.totalPages;
          totalShipmentsData = response.totalData;
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
          totalData: totalShipmentsData!,
          hasReachedMax: hasShipmentsReachedMax,
          currentPage: shipmentsPage));
    } on ServerErrorException catch (e) {
      emit(GetAllShipsFailState('${e.errorMessage} Please Login',
          statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(GetAllShipsFailState(e.toString()));
    }
  }

  void clearState() {
    emit(GetAllInitialState());
  }

  Future<void> searchShipments({
    required String? token,
    bool isPagination = false,
    isRefresh = false,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    String? toCity,
    bool? latest,
  }) async {
    if (!isPagination) {
      emit(SearchShipsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        // emit(GetAllShipsPaginationLoadingState('Loading...'));

        var response = await getAllShipmentsUsecase.invoke(
          token: token!,
          page: shipmentsPage,
          beforeExpectedDate: beforeExpectedDate,
          afterExpectedDate: afterExpectedDate,
          from: from,
          fromCity: fromCity,
          to: to,
          toCity: toCity,
          latest: latest,
        );
        totalShipmentPages = response.totalPages;
        print('total pages $totalShipmentPages');
        totalShipmentsData = response.totalData;
        print('pagination length ${shipments.length}');
        hasShipmentsReachedMax = response.shipments!.isEmpty;
        for (var shipment in response.shipments!) {
          shipments.add(shipment);
        }
      } else {
        if (isRefresh) {
          print('api refresh');
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(
            token: token!,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          shipments = response.shipments!;
          totalShipmentPages = response.totalPages;
          totalShipmentsData = response.totalData;

          print('total pages $totalShipmentPages');
          hasShipmentsReachedMax = response.shipments!.isEmpty;
        } else {
          print('api normal');
          shipmentsPage = 1;
          var response = await getAllShipmentsUsecase.invoke(
            token: token!,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          shipments = response.shipments!;
          hasShipmentsReachedMax = response.shipments!.isEmpty;
          totalShipmentPages = response.totalPages;
          totalShipmentsData = response.totalData;
        }
      }

      shipmentsPage++;
      print('page $shipmentsPage');
      // for (var shipment in response.shipments!) {
      //   shipments.add(shipment);
      // }

      // createUserInDb(user);
      emit(SearchShipsSuccessState(
          shipmentDto: shipments,
          totalPages: totalShipmentPages!,
          hasReachedMax: hasShipmentsReachedMax,
          totalData: totalShipmentsData!,
          currentPage: shipmentsPage));
    } on ServerErrorException catch (e) {
      emit(SearchShipsFailState('${e.errorMessage} Please Login',
          statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(SearchShipsFailState(e.toString()));
    }
  }

  // Future<void> refreshAccessToken() async {
  //   // emit(GetAllShipsLoadingState('Loading...'));

  //   try {
  //     String newAccessToken = await apiManager.refreshAccessToken();
  //     await const FlutterSecureStorage()
  //         .write(key: 'accessToken', value: newAccessToken);
  //     print('new tokennnnnnnnn $newAccessToken');
  //     await getAllShipments(token: newAccessToken);
  //   } on ServerErrorException catch (e) {
  //     emit(RefreshTokenFailState(e.errorMessage));
  //   } on Exception catch (e) {
  //     emit(RefreshTokenFailState(e.toString()));
  //   }
  // }

  Future<void> getAlltrips({
    required String token,
    bool isPagination = false,
    isRefresh = false,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    bool? latest,
    String? toCity,
  }) async {
    if (!isPagination) {
      emit(GetAllTripsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        print('page pagination $tripsPage');
        // emit(GetAllTripsPaginationLoadingState('Loading...'));
        var response = await getAllTripsUsecase.invoke(
          token: token,
          page: tripsPage,
          beforeExpectedDate: beforeExpectedDate,
          afterExpectedDate: afterExpectedDate,
          from: from,
          fromCity: fromCity,
          to: to,
          toCity: toCity,
          latest: latest,
        );
        totalTripsPages = response.totalPages;
        hasTripsReachedMax = response.trips!.isEmpty;
        totalTripsData = response.totalData;

        for (var trip in response.trips!) {
          trips.add(trip);
        }
      } else {
        if (isRefresh) {
          tripsPage = 1;
          var response = await getAllTripsUsecase.invoke(
            token: token,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          trips = response.trips!;
          totalTripsPages = response.totalPages;
          totalTripsData = response.totalData;

          hasTripsReachedMax = response.trips!.isEmpty;
        } else {
          var response = await getAllTripsUsecase.invoke(
            token: token,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          trips = response.trips!;
          totalTripsPages = response.totalPages;
          tripsPage = 1;
          hasTripsReachedMax = response.trips!.isEmpty;
          totalTripsData = response.totalData;
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
          totalData: totalTripsData!,
          currentPage: tripsPage));
    } on ServerErrorException catch (e) {
      emit(GetAllTripsFailState(
          failMessage: e.errorMessage, statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(GetAllTripsFailState(failMessage: e.toString()));
    }
  }

  Future<void> searchTrips({
    required String token,
    bool isPagination = false,
    isRefresh = false,
    String? beforeExpectedDate,
    String? afterExpectedDate,
    String? from,
    String? fromCity,
    String? to,
    bool? latest,
    String? toCity,
  }) async {
    if (!isPagination) {
      emit(SearchTripsLoadingState('Loading...'));
    }

    try {
      if (isPagination) {
        print('page pagination $tripsPage');
        // emit(GetAllTripsPaginationLoadingState('Loading...'));
        var response = await getAllTripsUsecase.invoke(
          token: token,
          page: tripsPage,
          beforeExpectedDate: beforeExpectedDate,
          afterExpectedDate: afterExpectedDate,
          from: from,
          fromCity: fromCity,
          to: to,
          toCity: toCity,
          latest: latest,
        );
        totalTripsPages = response.totalPages;
        hasTripsReachedMax = response.trips!.isEmpty;
        totalTripsData = response.totalData;

        for (var trip in response.trips!) {
          trips.add(trip);
        }
      } else {
        if (isRefresh) {
          tripsPage = 1;
          var response = await getAllTripsUsecase.invoke(
            token: token,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          trips = response.trips!;
          totalTripsPages = response.totalPages;
          totalTripsData = response.totalData;

          hasTripsReachedMax = response.trips!.isEmpty;
        } else {
          var response = await getAllTripsUsecase.invoke(
            token: token,
            beforeExpectedDate: beforeExpectedDate,
            afterExpectedDate: afterExpectedDate,
            from: from,
            fromCity: fromCity,
            to: to,
            toCity: toCity,
            latest: latest,
          );
          trips = response.trips!;
          totalTripsPages = response.totalPages;
          tripsPage = 1;
          hasTripsReachedMax = response.trips!.isEmpty;
          totalTripsData = response.totalData;
        }
      }
      tripsPage++;
      print('page $tripsPage');
      // for (var shipment in response.shipments!) {
      //   shipments.add(shipment);
      // }

      // createUserInDb(user);
      emit(SearchTripsSuccessState(
          tripsDto: trips,
          hasReachedMax: hasTripsReachedMax,
          totalPages: totalTripsPages!,
          totalData: totalTripsData!,
          currentPage: tripsPage));
    } on ServerErrorException catch (e) {
      emit(SearchTripsFailState(
          failMessage: e.errorMessage, statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(SearchTripsFailState(failMessage: e.toString()));
    }
  }
}

abstract class HomeViewState {}

class GetAllInitialState extends HomeViewState {}

class GetAllShipsSuccessState extends HomeViewState {
  List<ShipmentDto> shipmentDto;
  bool hasReachedMax;
  int currentPage, totalPages, totalData;

  GetAllShipsSuccessState(
      {required this.hasReachedMax,
      required this.totalPages,
      required this.totalData,
      required this.shipmentDto,
      required this.currentPage});
}

class GetAllShipsLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllShipsLoadingState(this.loadingMessage);
}

class SearchShipsSuccessState extends HomeViewState {
  List<ShipmentDto> shipmentDto;
  bool hasReachedMax;
  int currentPage, totalPages, totalData;

  SearchShipsSuccessState(
      {required this.hasReachedMax,
      required this.totalPages,
      required this.shipmentDto,
      required this.totalData,
      required this.currentPage});
}

class SearchShipsLoadingState extends HomeViewState {
  String loadingMessage;

  SearchShipsLoadingState(this.loadingMessage);
}

class SearchShipsFailState extends HomeViewState {
  String failMessage;
  int? statusCode;
  SearchShipsFailState(this.failMessage, {this.statusCode});
}

class SearchTripsSuccessState extends HomeViewState {
  List<TripsDto> tripsDto;
  bool hasReachedMax;
  int currentPage, totalPages, totalData;

  SearchTripsSuccessState(
      {required this.hasReachedMax,
      required this.totalPages,
      required this.tripsDto,
      required this.totalData,
      required this.currentPage});
}

class SearchTripsLoadingState extends HomeViewState {
  String loadingMessage;

  SearchTripsLoadingState(this.loadingMessage);
}

class SearchTripsFailState extends HomeViewState {
  String? failMessage;
  int? statusCode;
  SearchTripsFailState({this.failMessage, this.statusCode});
}

class GetAllShipsFailState extends HomeViewState {
  String failMessage;
  int? statusCode;
  GetAllShipsFailState(this.failMessage, {this.statusCode});
}

class GetAllTripsSuccessState extends HomeViewState {
  List<TripsDto> tripsDto;
  bool hasReachedMax;
  int currentPage, totalPages, totalData;

  GetAllTripsSuccessState(
      {required this.currentPage,
      required this.totalPages,
      required this.totalData,
      required this.hasReachedMax,
      required this.tripsDto});
}

class GetAllTripsLoadingState extends HomeViewState {
  String loadingMessage;

  GetAllTripsLoadingState(this.loadingMessage);
}

class GetAllTripsFailState extends HomeViewState {
  String failMessage;
  int? statusCode;

  GetAllTripsFailState({required this.failMessage, this.statusCode});
}

class RefreshTokenSuccessState extends HomeViewState {
  String newAccessToken;

  RefreshTokenSuccessState({required this.newAccessToken});
}

class RefreshTokenFailState extends HomeViewState {
  String failMessage;

  RefreshTokenFailState(this.failMessage);
}
