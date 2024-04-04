import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.rectangle, border: Border.all(color: Colors.grey.shade300, width: 0.5)),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text(
                "친구 (하단의 친구 아이콘을 눌러서 추가하세요.)",
                style: TextStyle(fontSize: 10, color: Colors.blueGrey),
              ),
            ),
            Text("data"),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50, right: 35),
        child: FloatingActionButton(
          child: const Icon(Icons.person_2),
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
