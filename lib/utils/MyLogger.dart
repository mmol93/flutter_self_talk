import 'package:logger/logger.dart';

class MyLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // 호출 메소드 스택을 얼마나 보여줄지 설정
      errorMethodCount: 5, // 에러가 발생했을 때 보여줄 메소드 스택의 수
      lineLength: 120, // 로그 한 줄의 길이
      colors: true, // 로그에 색상 사용 여부
      printEmojis: true, // 이모지 사용 여부
      printTime: false, // 메시지 앞에 시간 출력 여부
    ),
    filter: ProductionFilter(), // 로그 레벨 필터링 (예: Production에서는 verbose 로그 제외)
  );

  static void log(String message) {
    _logger.d("MyLogger: $message");
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e("MyLogger: $message");
  }
}
