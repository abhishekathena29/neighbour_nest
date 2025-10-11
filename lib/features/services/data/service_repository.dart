import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/service_model.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Create a new service
  Future<String> createService(ServiceModel service) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.servicesCollection)
          .add(service.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  // Get all services
  Stream<List<ServiceModel>> getAllServices() {
    return _firestore
        .collection(AppConstants.servicesCollection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get services by contributor
  Stream<List<ServiceModel>> getServicesByContributor(String contributorId) {
    return _firestore
        .collection(AppConstants.servicesCollection)
        .where('contributorId', isEqualTo: contributorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get services by category
  Stream<List<ServiceModel>> getServicesByCategory(String category) {
    return _firestore
        .collection(AppConstants.servicesCollection)
        .where('category', isEqualTo: category)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get single service
  Future<ServiceModel?> getService(String serviceId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.servicesCollection)
          .doc(serviceId)
          .get();

      if (doc.exists) {
        return ServiceModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get service: $e');
    }
  }

  // Update service
  Future<void> updateService(
    String serviceId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = Timestamp.now();
      await _firestore
          .collection(AppConstants.servicesCollection)
          .doc(serviceId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

  // Delete service
  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore
          .collection(AppConstants.servicesCollection)
          .doc(serviceId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  // Search services
  Stream<List<ServiceModel>> searchServices(String query) {
    return _firestore
        .collection(AppConstants.servicesCollection)
        .where('status', isEqualTo: 'active')
        .orderBy('title')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get featured services (highly rated)
  Stream<List<ServiceModel>> getFeaturedServices() {
    return _firestore
        .collection(AppConstants.servicesCollection)
        .where('status', isEqualTo: 'active')
        .where('rating', isGreaterThan: 4.0)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ServiceModel.fromFirestore(doc))
              .toList();
        });
  }
}
