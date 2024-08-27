import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;

  WebSocketService(this.url);

  void connect(String userEmail) {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Gửi yêu cầu kết nối với email của người dùng
    _channel.sink.add(jsonEncode({'type': 'connect', 'email': userEmail}));

    // Lắng nghe tin nhắn từ server
    _channel.stream.listen((message) {
      _handleMessage(message);
    });
  }

  void disconnect() {
    _channel.sink.add(jsonEncode({'type': 'disconnect'}));
    _channel.sink.close();
  }

  void _handleMessage(String message) {
    // Xử lý tin nhắn từ server
    print("Received message: $message");

    // Ví dụ: Nếu nhận được thông báo đăng xuất
    var decodedMessage = jsonDecode(message);
    if (decodedMessage['type'] == 'logout') {
      // Xử lý đăng xuất
      print("Logging out due to message from server");
      // Thực hiện đăng xuất hoặc thông báo cho người dùng
    }
  }

  void sendMessage(String message) {
    _channel.sink.add(message);
  }
}
