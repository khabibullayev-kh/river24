
import 'package:outsource/data/repository/pin_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/data/repository/user_repository.dart';

class LogoutInteractor {
  static Future<void> logout() async {
    await PinRepository.getInstance().savePin(null);
    await TokenRepository.getInstance().saveToken(null);
    await UserRepository.getInstance().saveUser(null);
  }
}
