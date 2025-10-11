import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceStatus { active, inactive, completed, cancelled }

enum ServiceType { oneTime, recurring, workshop }

class ServiceModel {
  final String id;
  final String contributorId;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final ServiceType serviceType;
  final ServiceStatus status;
  final double? price;
  final String? currency;
  final String? location;
  final bool isOnline;
  final DateTime? availableFrom;
  final DateTime? availableTo;
  final List<String> images;
  final int maxParticipants;
  final int currentParticipants;
  final double rating;
  final int totalRatings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? requirements;
  final String? contactInfo;

  ServiceModel({
    required this.id,
    required this.contributorId,
    required this.title,
    required this.description,
    required this.category,
    this.tags = const [],
    required this.serviceType,
    this.status = ServiceStatus.active,
    this.price,
    this.currency = 'INR',
    this.location,
    this.isOnline = false,
    this.availableFrom,
    this.availableTo,
    this.images = const [],
    this.maxParticipants = 1,
    this.currentParticipants = 0,
    this.rating = 0.0,
    this.totalRatings = 0,
    required this.createdAt,
    required this.updatedAt,
    this.requirements,
    this.contactInfo,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      contributorId: data['contributorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      serviceType: ServiceType.values.firstWhere(
        (e) => e.toString() == 'ServiceType.${data['serviceType']}',
        orElse: () => ServiceType.oneTime,
      ),
      status: ServiceStatus.values.firstWhere(
        (e) => e.toString() == 'ServiceStatus.${data['status']}',
        orElse: () => ServiceStatus.active,
      ),
      price: data['price']?.toDouble(),
      currency: data['currency'] ?? 'INR',
      location: data['location'],
      isOnline: data['isOnline'] ?? false,
      availableFrom: data['availableFrom'] != null
          ? (data['availableFrom'] as Timestamp).toDate()
          : null,
      availableTo: data['availableTo'] != null
          ? (data['availableTo'] as Timestamp).toDate()
          : null,
      images: List<String>.from(data['images'] ?? []),
      maxParticipants: data['maxParticipants'] ?? 1,
      currentParticipants: data['currentParticipants'] ?? 0,
      rating: data['rating']?.toDouble() ?? 0.0,
      totalRatings: data['totalRatings'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      requirements: data['requirements'],
      contactInfo: data['contactInfo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'contributorId': contributorId,
      'title': title,
      'description': description,
      'category': category,
      'tags': tags,
      'serviceType': serviceType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'price': price,
      'currency': currency,
      'location': location,
      'isOnline': isOnline,
      'availableFrom': availableFrom != null
          ? Timestamp.fromDate(availableFrom!)
          : null,
      'availableTo': availableTo != null
          ? Timestamp.fromDate(availableTo!)
          : null,
      'images': images,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'rating': rating,
      'totalRatings': totalRatings,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'requirements': requirements,
      'contactInfo': contactInfo,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? contributorId,
    String? title,
    String? description,
    String? category,
    List<String>? tags,
    ServiceType? serviceType,
    ServiceStatus? status,
    double? price,
    String? currency,
    String? location,
    bool? isOnline,
    DateTime? availableFrom,
    DateTime? availableTo,
    List<String>? images,
    int? maxParticipants,
    int? currentParticipants,
    double? rating,
    int? totalRatings,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? requirements,
    String? contactInfo,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      contributorId: contributorId ?? this.contributorId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      images: images ?? this.images,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      requirements: requirements ?? this.requirements,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}
