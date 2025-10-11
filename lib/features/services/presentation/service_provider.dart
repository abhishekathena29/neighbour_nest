import 'package:flutter/foundation.dart';
import '../../../shared/models/service_model.dart';
import '../data/service_repository.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceRepository _serviceRepository = ServiceRepository();

  List<ServiceModel> _services = [];
  List<ServiceModel> _myServices = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'all';

  List<ServiceModel> get services => _services;
  List<ServiceModel> get myServices => _myServices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  // Get all services
  void loadAllServices() {
    _setLoading(true);
    _clearError();

    _serviceRepository.getAllServices().listen(
      (services) {
        _services = services;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = error.toString();
        _setLoading(false);
      },
    );
  }

  // Get services by contributor
  void loadMyServices(String contributorId) {
    _setLoading(true);
    _clearError();

    _serviceRepository
        .getServicesByContributor(contributorId)
        .listen(
          (services) {
            _myServices = services;
            _setLoading(false);
          },
          onError: (error) {
            _errorMessage = error.toString();
            print(_errorMessage);
            _setLoading(false);
          },
        );
  }

  // Get services by category
  void loadServicesByCategory(String category) {
    _setLoading(true);
    _clearError();
    _selectedCategory = category;

    if (category == 'all') {
      loadAllServices();
    } else {
      _serviceRepository
          .getServicesByCategory(category)
          .listen(
            (services) {
              _services = services;
              _setLoading(false);
            },
            onError: (error) {
              _errorMessage = error.toString();
              print(_errorMessage);
              _setLoading(false);
            },
          );
    }
  }

  // Create service
  Future<bool> createService(ServiceModel service) async {
    _setLoading(true);
    _clearError();

    try {
      await _serviceRepository.createService(service);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Update service
  Future<bool> updateService(
    String serviceId,
    Map<String, dynamic> updates,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _serviceRepository.updateService(serviceId, updates);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print(_errorMessage);
      _setLoading(false);
      return false;
    }
  }

  // Delete service
  Future<bool> deleteService(String serviceId) async {
    _setLoading(true);
    _clearError();

    try {
      await _serviceRepository.deleteService(serviceId);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print(_errorMessage);
      _setLoading(false);
      return false;
    }
  }

  // Search services
  void searchServices(String query) {
    if (query.isEmpty) {
      loadAllServices();
      return;
    }

    _setLoading(true);
    _clearError();

    _serviceRepository
        .searchServices(query)
        .listen(
          (services) {
            _services = services;
            _setLoading(false);
          },
          onError: (error) {
            _errorMessage = error.toString();
            print(_errorMessage);
            _setLoading(false);
          },
        );
  }

  // Get featured services
  void loadFeaturedServices() {
    _setLoading(true);
    _clearError();

    _serviceRepository.getFeaturedServices().listen(
      (services) {
        _services = services;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = error.toString();
        print(_errorMessage);
        _setLoading(false);
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
