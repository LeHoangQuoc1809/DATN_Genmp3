import 'package:client/models/history_model.dart';

import '../../services/service_mng.dart';
import '../models/user_model.dart';

class HistoryModelview {
  HistoryModelview();

  Future<List<History>> getHistorysByUserEmail({
    required String email,
  }) async {
    List<History> historys = [];
    final data = await ServiceManager.historyService.getHistorysByUserEmail(email: email);
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      historys = list.map((i) => History.fromJson(i)).toList();
    } else {
      print(data['message']);
    }
    return historys;
  }
}
