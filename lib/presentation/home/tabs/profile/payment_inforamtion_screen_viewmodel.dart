import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/data/datasource/payment_info_datasource_impl.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/payment_info_repository_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/datasource/payment_info_datasource.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';
import 'package:hatly/domain/repository/payment_info_repository.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_all_shipments_usecase.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';
import 'package:hatly/domain/usecase/update_payment_inforamtion_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class PaymentInformationScreenViewModel extends Cubit<PaymentInfoViewState> {
  late ApiManager apiManager;
  late PaymentInfoRepository paymentInfoRepository;
  late PaymentInfoDatasource paymentInfoDatasource;
  late UpdatePaymentInformationUsecase usecase;
  // AccessTokenProvider accessTokenProvider;

  PaymentInformationScreenViewModel() : super(UpdatePaymentInfoInitialState()) {
    apiManager = ApiManager();
    paymentInfoDatasource = PaymentInfoDatasourceImpl(apiManager);
    paymentInfoRepository = PaymentInfoRepositoryImpl(paymentInfoDatasource);
    usecase = UpdatePaymentInformationUsecase(paymentInfoRepository);
  }

  void updatePaymentInfo(
      {String? accountNumber,
      String? routingNumber,
      String? accountName,
      String? accountCurrency,
      String? accountCountry,
      int? userid}) async {
    emit(UpdatePaymentInfoLoadingState('Loading...'));
    try {
      var response = await usecase.updatePaymentInfo(
        accountNumber: accountNumber,
        accountName: accountName,
        accountCountry: accountCountry,
        accountCurrency: accountCurrency,
        userid: userid,
        routingNumber: routingNumber,
      );
      emit(UpdatePaymentInfoSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(
          UpdatePaymentInfoFailState(e.errorMessage, statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(UpdatePaymentInfoFailState(e.toString()));
    }
  }
}

abstract class PaymentInfoViewState {}

class UpdatePaymentInfoInitialState extends PaymentInfoViewState {}

class UpdatePaymentInfoSuccessState extends PaymentInfoViewState {
  UpdatePaymentInfoResponseDto responseDto;

  UpdatePaymentInfoSuccessState(
    this.responseDto,
  );
}

class UpdatePaymentInfoLoadingState extends PaymentInfoViewState {
  String loadingMessage;

  UpdatePaymentInfoLoadingState(this.loadingMessage);
}

class UpdatePaymentInfoFailState extends PaymentInfoViewState {
  String failMessage;
  int? statusCode;
  UpdatePaymentInfoFailState(this.failMessage, {this.statusCode});
}
