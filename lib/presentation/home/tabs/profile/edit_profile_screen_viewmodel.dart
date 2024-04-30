import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/data/datasource/profile_datasource_impl.dart';
import 'package:hatly/data/datasource/shipment_datasource_impl.dart';
import 'package:hatly/data/datasource/trips_datasource_impl.dart';
import 'package:hatly/data/repository/profile_repository_impl.dart';
import 'package:hatly/data/repository/shipment_repository_impl.dart';
import 'package:hatly/data/repository/trips_repository_impl.dart';
import 'package:hatly/domain/datasource/profile_datasource.dart';
import 'package:hatly/domain/datasource/shipment_datasource.dart';
import 'package:hatly/domain/datasource/trips_datasource.dart';
import 'package:hatly/domain/models/create_shipment_response_dto.dart';
import 'package:hatly/domain/models/get_all_shipments_dto.dart';
import 'package:hatly/domain/models/get_all_trips_response_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/domain/models/update_payment_info_response_dto.dart';
import 'package:hatly/domain/repository/profile_repository.dart';
import 'package:hatly/domain/repository/shipment_repository.dart';
import 'package:hatly/domain/repository/trips_repository.dart';
import 'package:hatly/domain/usecase/create_shipment_usecase.dart';
import 'package:hatly/domain/usecase/get_all_shipments_usecase.dart';
import 'package:hatly/domain/usecase/get_all_trips_usecase.dart';
import 'package:hatly/domain/usecase/update_payment_inforamtion_usecase.dart';
import 'package:hatly/domain/usecase/update_profile_usecase.dart';
import 'package:hatly/providers/access_token_provider.dart';

import '../../../../data/api/api_manager.dart';
import '../../../../domain/customException/custom_exception.dart';
import '../../../../domain/models/item_dto.dart';

class EditProfileScreenViewModel extends Cubit<UpdateProfileViewState> {
  late ApiManager apiManager;
  late ProfileRepository profileRepository;
  late ProfileDatasource profileDatasource;
  late UpdateProfileUsecase usecase;
  AccessTokenProvider accessTokenProvider;

  EditProfileScreenViewModel(this.accessTokenProvider)
      : super(UUpdateProfileInitialState()) {
    apiManager = ApiManager(accessTokenProvider: accessTokenProvider);
    profileDatasource = PaymentInfoDatasourceImpl(apiManager);
    profileRepository = PaymentInfoRepositoryImpl(profileDatasource);
    usecase = UpdateProfileUsecase(profileRepository);
  }

  void updateProfile(
      {String? dob,
      String? address,
      String? city,
      String? country,
      String? postalCode,
      String? ip,
      required String? accessToken,
      String? phone}) async {
    emit(UpdateProfileLoadingState('Loading...'));
    try {
      var response = await usecase.updateProfile(
        dob: dob,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
        ip: ip,
        accessToken: accessToken,
        phone: phone,
      );
      emit(UpdateProfileSuccessState(response));
    } on ServerErrorException catch (e) {
      emit(UpdateProfileFailState(e.errorMessage, statusCode: e.statusCode));
    } on Exception catch (e) {
      emit(UpdateProfileFailState(e.toString()));
    }
  }
}

abstract class UpdateProfileViewState {}

class UUpdateProfileInitialState extends UpdateProfileViewState {}

class UpdateProfileSuccessState extends UpdateProfileViewState {
  UpdatePaymentInfoResponseDto responseDto;

  UpdateProfileSuccessState(
    this.responseDto,
  );
}

class UpdateProfileLoadingState extends UpdateProfileViewState {
  String loadingMessage;

  UpdateProfileLoadingState(this.loadingMessage);
}

class UpdateProfileFailState extends UpdateProfileViewState {
  String failMessage;
  int? statusCode;
  UpdateProfileFailState(this.failMessage, {this.statusCode});
}
