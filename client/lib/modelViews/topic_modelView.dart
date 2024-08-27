import '../../models/song_model.dart';
import '../../models/topic_model.dart';
import '../../services/service_mng.dart';

class TopicModelviews {
  TopicModelviews();

  Future<List<Topic>> getAllTopics() async {
    List<Topic> topics = [];
    final data = await ServiceManager.topicService.getAllTopics();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      topics = list.map((i) => Topic.fromJson(i)).toList();
    } else {
      print(data);
    }
    return topics;
  }

  Future<List<Topic>> getTop3Topics() async {
    List<Topic> topics = [];
    final data = await ServiceManager.topicService.getTop3Topics();
    if (data['message'] == "OK") {
      var list = data['data'] as List;
      topics = list.map((i) => Topic.fromJson(i)).toList();
    } else {
      print(data);
    }
    return topics;
  }
}
