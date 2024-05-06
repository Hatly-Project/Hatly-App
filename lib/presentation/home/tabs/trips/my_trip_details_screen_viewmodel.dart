import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/api/trip_matching_shipments_response/trip_matching_shipments_response.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/models/my_trip_deals_response_dto.dart';
import 'package:hatly/domain/models/trip_matching_shipments_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/get_my_shipment_deals_usecase.dart';
import 'package:hatly/domain/usecase/get_my_trip_deals_usecase.dart';
import 'package:hatly/domain/usecase/get_my_trip_matching_shipments_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

class MyTripDetailsScreenViewModel extends Cubit<MyTripDetailsViewState> {
  late ApiManager apiManager;
  late TripsRepository tripsRepository;
  late TripsDatasource tripsDatasource;
  late GetMyTripDealsUsecase getMyTripDealsUsecase;
  late GetMyTripMatchingShipmentsUsecase getMyTripMatchingShipmentsUsecase;
  AccessTokenProvider? accessTokenProvider;
  MyTripDetailsScreenViewModel({this.accessTokenProvider})
      : super(MyTripDetailsInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    tripsDatasource = TripsDatasourceImpl(apiManager);
    tripsRepository = TripsRepositoryImpl(tripsDatasource);
    getMyTripDealsUsecase = GetMyTripDealsUsecase(tripsRepository);
    getMyTripMatchingShipmentsUsecase =
        GetMyTripMatchingShipmentsUsecase(repository: tripsRepository);
  }

  Future<void> getMyTripDeals(
      {required String token, required int tripId}) async {
    emit(MyTripDealsLoadingState(loadingMessage: 'Loading... '));

    try {
      var response = await getMyTripDealsUsecase.getMytripDeals(
          token: token, tripId: tripId);

      emit(MyTripDealsSuccessState(responseDto: response));
    } on ServerErrorException catch (e) {
      emit(MyTripDealsFailState(failMessage: e.errorMessage));
    }
  }

  Future<void> getMyTripMatchingShipments(
      {required String token, required int tripId}) async {
    emit(GetTripMatchingShipmentsLoadingState(loadingMessage: 'Loading... '));

    try {
      var response = await getMyTripMatchingShipmentsUsecase.invoke(
          token: token, tripId: tripId);

      emit(GetTripMatchingShipmentsSuccessState(responseDto: response));
    } on ServerErrorException catch (e) {
      emit(GetTripMatchingShipmentsFailState(failMessage: e.errorMessage));
    }
  }
}

abstract class MyTripDetailsViewState {}

class MyTripDetailsInitialState extends MyTripDetailsViewState {}

class MyTripDealsLoadingState extends MyTripDetailsViewState {
  String loadingMessage;

  MyTripDealsLoadingState({required this.loadingMessage});
}

class MyTripDealsSuccessState extends MyTripDetailsViewState {
  MyTripDealsResponseDto responseDto;

  MyTripDealsSuccessState({required this.responseDto});
}

class MyTripDealsFailState extends MyTripDetailsViewState {
  String failMessage;

  MyTripDealsFailState({required this.failMessage});
}

class GetTripMatchingShipmentsSuccessState extends MyTripDetailsViewState {
  TripMatchingShipmentsResponseDto responseDto;

  GetTripMatchingShipmentsSuccessState({required this.responseDto});
}

class GetTripMatchingShipmentsLoadingState extends MyTripDetailsViewState {
  String? loadingMessage;

  GetTripMatchingShipmentsLoadingState({this.loadingMessage});
}

class GetTripMatchingShipmentsFailState extends MyTripDetailsViewState {
  String? failMessage;

  GetTripMatchingShipmentsFailState({this.failMessage});
}
