import 'package:themovie_db/domain/data_providers/session_data_provider.dart';

class MyAppModel {
  final _seesionDataProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> chekAuth() async {
    final sessionId = await _seesionDataProvider.getSessionId();
    _isAuth = sessionId != null;
  }
} 