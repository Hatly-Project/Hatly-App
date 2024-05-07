import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/firebase/firebase_manger.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/message_model.dart';
import 'package:hatly/domain/models/user_model.dart';

class ChatScreenViewModel extends Cubit<ChatViewState> {
  late FirebaseManger firebaseManger;
  ChatScreenViewModel() : super(ChatInitialState());

  Future<void> createDealCollection(DealDto deal) async {
    try {
      emit(CreateDealCollectionLoadingState());

      print('call firebase');
      await FirebaseManger.createDealCollection(deal);
      emit(CreateDealCollectionSuccessState());
    } on FirebaseException catch (e) {
      CreateDealCollectionFailState(failMessage: e.message);
    } on Exception catch (e) {
      CreateDealCollectionFailState(failMessage: e.toString());
    }
  }

  void sendMessage(String messageContent, UserDto userDto, DealDto dealDto) {
    var message = MessageModel(
      content: messageContent,
      datetime: DateTime.now(),
      senderId: userDto.id.toString(),
      senderName: '${userDto.firstName} ${userDto.lastName}',
      dealId: dealDto.id.toString(),
    );
    FirebaseManger.sendMessage(messageModel: message, dealDto: dealDto)
        .then((value) {
      emit(SendMessageSuccessState());
    }).onError((error, stackTrace) {
      emit(SendMessageFailState(failMessage: error.toString()));
    });
  }
}

abstract class ChatViewState {}

class ChatInitialState extends ChatViewState {}

class CreateDealCollectionSuccessState extends ChatViewState {}

class CreateDealCollectionLoadingState extends ChatViewState {}

class SendMessageSuccessState extends ChatViewState {}

class SendMessageFailState extends ChatViewState {
  String? failMessage;
  SendMessageFailState({required this.failMessage});
}

class CreateDealCollectionFailState extends ChatViewState {
  String? failMessage;

  CreateDealCollectionFailState({required this.failMessage});
}
