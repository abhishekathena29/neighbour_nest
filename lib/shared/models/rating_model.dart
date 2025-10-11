import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String serviceId;
  final String customerId;
  final String contributorId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  RatingModel({
    required this.id,
    required this.serviceId,
    required this.customerId,
    required this.contributorId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RatingModel(
      id: doc.id,
      serviceId: data['serviceId'] ?? '',
      customerId: data['customerId'] ?? '',
      contributorId: data['contributorId'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
      comment: data['comment'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'serviceId': serviceId,
      'customerId': customerId,
      'contributorId': contributorId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  RatingModel copyWith({
    String? id,
    String? serviceId,
    String? customerId,
    String? contributorId,
    double? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RatingModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      customerId: customerId ?? this.customerId,
      contributorId: contributorId ?? this.contributorId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
