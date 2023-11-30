class TokenStorage {
  static String? _idToken;

  static String? get idToken => _idToken;

  static void setToken(String? token) {
    _idToken = token;
  }
}
