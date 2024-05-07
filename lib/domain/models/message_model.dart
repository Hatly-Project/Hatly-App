import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  static const collectionName = 'Message';
  String? content;
  String? senderName;
  String? senderId;
  DateTime? datetime;
  String? dealId;

  MessageModel({
    this.content,
    this.senderName,
    this.senderId,
    this.datetime,
    this.dealId,
  });

  MessageModel.fromFirestore(Map<String, dynamic> data) {
    content = data['content'];
    senderName = data['senderName'];
    senderId = data['senderId'];
    datetime = (data['datetime'] as Timestamp).toDate();
    dealId = data['dealId'];
  }

  Map<String, dynamic> toFireStore() => {
        'content': content,
        'senderName': senderName,
        'senderId': senderId,
        'datetime': datetime,
        'dealId': dealId,
      };
}
