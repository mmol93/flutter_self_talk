import 'package:flutter/material.dart';
import 'package:self_talk/viewModel/password_viewModel.dart';

import '../../colors/default_color.dart';

class PasswordInputScreen extends StatefulWidget {
  final bool isSetup;
  final bool isInit;
  final VoidCallback? onPasswordVerified;

  const PasswordInputScreen({
    Key? key,
    this.isSetup = false,
    this.onPasswordVerified,
    this.isInit = false,
  }) : super(key: key);

  @override
  State<PasswordInputScreen> createState() => _PasswordInputScreenState();
}

class _PasswordInputScreenState extends State<PasswordInputScreen> {
  late final String? displayTitle;

  @override
  void initState() {
    if (widget.isInit) {
      displayTitle = "비밀번호 초기화";
    } else if(widget.isSetup) {
      displayTitle = "비밀번호 설정";
    } else {
      displayTitle = "비밀번호 입력";
    }
    super.initState();
  }
  final List<String> _password = [];
  final int _requiredLength = 4;
  final passwordViewModel = PasswordViewModel();

  Future<void> _handlePasswordInput(String digit) async {
    if (_password.length < _requiredLength) {
      setState(() {
        _password.add(digit);
      });

      if (_password.length == _requiredLength) {
        await _processPassword();
      }
    }
  }

  Future<void> _processPassword() async {
    String enteredPassword = _password.join();

    if (widget.isSetup) {
      // 비밀번호 설정 모드
      passwordViewModel.setPassword(enteredPassword);

      // 비동기 작업 후 컨텍스트 사용 시 mounted 체크
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      // 비밀번호 검증 모드
      String? savedPassword = await passwordViewModel.getPassword();

      // 비동기 작업 후 컨텍스트 사용 시 mounted 체크
      if (!mounted) return;

      if (savedPassword == enteredPassword) {
        // 비밀번호 일치
        if (widget.isInit) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('비밀번호를 삭제했습니다.')));
          passwordViewModel.initPassword();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('비밀번호가 일치합니다.')));
        }

        // 선택적 콜백 호출
        widget.onPasswordVerified?.call();
        Navigator.pop(context);
      } else {
        // 비밀번호 불일치
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("비밀번호가 일치하지 않습니다.: $savedPassword}}")));

        // 입력 초기화
        setState(() {
          _password.clear();
        });
      }
    }
  }

  void _deleteLastDigit() {
    setState(() {
      if (_password.isNotEmpty) {
        _password.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle ?? "비밀번호 입력"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 비밀번호 입력 상태 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_requiredLength, (index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < _password.length ? defaultYellow : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // 숫자 패드
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              ...List.generate(9, (index) {
                return PasswordButton(
                  label: '${index + 1}',
                  onPressed: () => _handlePasswordInput('${index + 1}'),
                );
              }),
              // 삭제 버튼
              IconButton(
                icon: const Icon(Icons.backspace),
                onPressed: _deleteLastDigit,
              ),
              // 0 버튼
              PasswordButton(
                label: '0',
                onPressed: () => _handlePasswordInput('0'),
              ),
              // 빈 공간
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class PasswordButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PasswordButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 24)),
    );
  }
}
