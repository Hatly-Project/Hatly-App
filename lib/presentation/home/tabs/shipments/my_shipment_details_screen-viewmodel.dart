import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/models/my_shipment_deals_response_dto.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/usecase/get_my_shipment_deals_usecase.dart';

class MyShipmentDetailsScreenViewModel
    extends Cubit<MyShipmentDetailsViewState> {
  late ApiManager apiManager;
  late ShipmentRepository shipmentRepository;
  late ShipmentDataSource shipmentDataSource;
  late GetMyShipmentDealsUsecase getMyShipmentDealsUsecase;

  MyShipmentDetailsScreenViewModel() : super(MyshipmentDetailsInitialState()) {
    apiManager = ApiManager();
    shipmentDataSource = ShipmentDataSourceImpl(apiManager);
    shipmentRepository = ShipmentRepositoryImpl(shipmentDataSource);
    getMyShipmentDealsUsecase = GetMyShipmentDealsUsecase(shipmentRepository);
  }

  Future<void> getMyshipmentDeals(
      {required String token, required int shipmentId}) async {
    emit(MyshipmentDealsLoadingState(loadingMessage: 'Loading... '));

    try {
      var response = await getMyShipmentDealsUsecase.getMyShipmentDeals(
          token: token, shipmentId: shipmentId);

      emit(MyshipmentDealsSuccessState(responseDto: response));
    } on ServerErrorException catch (e) {
      emit(MyshipmentDealsFailState(failMessage: e.errorMessage));
    }
  }
}

abstract class MyShipmentDetailsViewState {}

class MyshipmentDetailsInitialState extends MyShipmentDetailsViewState {}

class MyshipmentDealsLoadingState extends MyShipmentDetailsViewState {
  String loadingMessage;

  MyshipmentDealsLoadingState({required this.loadingMessage});
}

class MyshipmentDealsSuccessState extends MyShipmentDetailsViewState {
  MyShipmentDealsResponseDto responseDto;

  MyshipmentDealsSuccessState({required this.responseDto});
}

class MyshipmentDealsFailState extends MyShipmentDetailsViewState {
  String failMessage;

  MyshipmentDealsFailState({required this.failMessage});
}
