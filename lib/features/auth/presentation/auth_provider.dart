import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/models/user_model.dart';
import '../data/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? _user;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authRepository.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile() async {
    if (_user == null) return;

    try {
      _userProfile = await _authRepository.getUserProfile(_user!.uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user profile: $e';
      notifyListeners();
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType userType,
    String? address,
    String? societyName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final credential = await _authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _authRepository.createUserProfile(
        userId: credential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        userType: userType,
        address: address,
        societyName: societyName,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signOut();
      _user = null;
      _userProfile = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? societyName,
    String? profileImageUrl,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await _authRepository.updateUserProfile(
        userId: _user!.uid,
        name: name,
        phone: phone,
        address: address,
        societyName: societyName,
        profileImageUrl: profileImageUrl,
      );

      // Reload user profile
      await _loadUserProfile();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
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
