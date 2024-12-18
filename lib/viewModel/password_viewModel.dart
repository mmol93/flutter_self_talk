import 'package:self_talk/repository/password_repository.dart';

class PasswordViewModel {
  final passwordRepository = PasswordRepository();

  /// 비밀번호 셋팅
  void setPassword(String password) {
    passwordRepository.setPassword(password);
  }

  Future<String> getPassword() {
    return passwordRepository.getPassword();
  }

  /// 비밀번호 사용 해제
  void initPassword() {
    passwordRepository.setPassword("");
  }

  /// 비밀번호가 셋팅 되어 있는 상태인지
  Future<bool> isPasswordSet() async {
    return passwordRepository.isPasswordSet();
  }
}
