import '../../models/song.dart';
import '../../models/topic.dart';
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

  Future<List<Song>> getSongsByTopicId(int topic_id) async {
    List<Song> songs = [];
    final data = await ServiceManager.topicService.getTopicById(topic_id);
    if (data['message'] == "OK") {
      var list = data['data']['songs'] as List;
      songs = list.map((i) => Song.fromJson(i)).toList();
    } else {
      print(data);
    }
    return songs;
  }

  Future<Topic?> createTopic(
      {required String name, required String description}) async {
    final data = await ServiceManager.topicService
        .createTopic(name: name, description: description);
    Topic? newTopic;
    if (data['message'] == "OK") {
      newTopic = Topic.fromJson(data['data']);
    } else {
      print(data);
    }
    return newTopic;
  }

  Future<Topic?> updateTopicById({
    required int id,
    required String name,
    required String description,
  }) async {
    final data = await ServiceManager.topicService
        .updateTopic(id: id, name: name, description: description);
    Topic? newTopic;
    if (data['message'] == "OK") {
      newTopic = Topic.fromJson(data['data']);
    } else {
      print(data);
    }
    return newTopic;
  }

  Future<bool> deleteTopicById({required int id}) async {
    bool isDeleted = false;
    final data = await ServiceManager.topicService.deleteTopicById(id);
    if (data['message'] == "OK") {
      isDeleted = data['data'];
    } else {
      print(data);
    }
    return isDeleted;
  }
}
