enum MessageType {
  /// 나 자신이 보내는 프로필 사진 및 시간이 포함된 메시지
  sendInit,
  /// 나 자신이 동일한 시간에 보내는 메시지
  sendContinue,
  /// 다른 사람이 보내는 프로필 사진 및 시간이 포함된 메시지
  receiveInit,
  /// 다른 사람이 동일한 시간에 보내는 메시지
  receiveContinue,
}