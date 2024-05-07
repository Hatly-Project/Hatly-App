import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/domain/models/message_model.dart';

class FirebaseManger {
  static CollectionReference<DealDto> getDealsCollection() {
    try {
      return FirebaseFirestore.instance
          .collection(DealDto.collectionName)
          .withConverter<DealDto>(
            fromFirestore: (snapshot, _) =>
                DealDto.fromFirestore(snapshot.data()!),
            toFirestore: (deal, _) => deal.toFireStore(),
          );
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  static Future<void> createDealCollection(DealDto deal) {
    try {
      var docRef = getDealsCollection().doc(deal.id.toString());
      return docRef.set(deal);
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  static CollectionReference<MessageModel> getMessagesCollection(
      String dealId) {
    try {
      print('dl id $dealId');
      print('gettttttt');
      return FirebaseFirestore.instance
          .collection(DealDto.collectionName)
          .doc(dealId)
          .collection(MessageModel.collectionName)
          .withConverter<MessageModel>(
            fromFirestore: (snapshot, options) =>
                MessageModel.fromFirestore(snapshot.data()!),
            toFirestore: (message, _) => message.toFireStore(),
          );
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  static Stream<QuerySnapshot<MessageModel>>? listenMessagesCollection(
      String dealId) {
    try {
      print('listennn');
      return FirebaseFirestore.instance
          .collection(DealDto.collectionName)
          .doc(dealId)
          .collection(MessageModel.collectionName)
          .withConverter<MessageModel>(
            fromFirestore: (snapshot, options) =>
                MessageModel.fromFirestore(snapshot.data()!),
            toFirestore: (message, _) => message.toFireStore(),
          )
          .snapshots();
    } on FirebaseException catch (e) {
      throw ServerErrorException(errorMessage: e.message!);
    } on Exception catch (e) {
      throw ServerErrorException(errorMessage: e.toString());
    }
  }

  static Future<void> sendMessage(
      {required MessageModel messageModel, required DealDto dealDto}) {
    var messageDoc = getMessagesCollection(dealDto.id.toString()).doc();

    return messageDoc.set(messageModel);
  }
}
