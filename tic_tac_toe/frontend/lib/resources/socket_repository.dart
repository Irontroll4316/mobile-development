import 'package:tic_tac_toe/resources/socket_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {'nickname': nickname});
    }
  }
}
