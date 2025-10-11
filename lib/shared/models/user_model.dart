import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { contributor, customer }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profileImageUrl;
  final UserType userType;
  final String? address;
  final String? societyName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final double? rating;
  final int totalRatings;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImageUrl,
    required this.userType,
    this.address,
    this.societyName,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.rating,
    this.totalRatings = 0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${data['userType']}',
        orElse: () => UserType.customer,
      ),
      address: data['address'],
      societyName: data['societyName'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      rating: data['rating']?.toDouble(),
      totalRatings: data['totalRatings'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'userType': userType.toString().split('.').last,
      'address': address,
      'societyName': societyName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isVerified': isVerified,
      'rating': rating,
      'totalRatings': totalRatings,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImageUrl,
    UserType? userType,
    String? address,
    String? societyName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    double? rating,
    int? totalRatings,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      address: address ?? this.address,
      societyName: societyName ?? this.societyName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
    );
  }
}
