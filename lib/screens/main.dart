import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:self_talk/firebase_options.dart';
import 'package:self_talk/screens/home/chat_list_screen.dart';
import 'package:self_talk/screens/home/friend_list_screen.dart';
import 'package:self_talk/screens/setting/setting_list_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../assets/strings.dart';
import '../colors/default_color.dart';
import '../widgets/dialog/simple_dialog.dart';

const pageList = ["친구", "채팅", "설정"];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    // 기존 recordFlutterFatalError를 호출
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);

    // 추가적인 오류 처리
    FlutterError.presentError(errorDetails); // Flutter 기본 처리
  };

  // 비동기 오류 처리
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nanumGothicTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: '셀프톡썰'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showTextDialog(
        context: context,
        title: Strings.startCautionTitle,
        contentText: Strings.startCautionContent,
        okText: Strings.okPolite,
      );
    });
  }

  void _updateBarIndicator(index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  Widget _viewPagerTitleWidget(String viewPagerTitle, int tabButtonIndex) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          viewPagerTitle,
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          _updateBarIndicator(tabButtonIndex);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double totalWidth = screenWidth;
    double barWidth = totalWidth / pageList.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppbarColor,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: pageList
                .asMap()
                .map((index, pageTitle) =>
                    MapEntry(index, _viewPagerTitleWidget(pageTitle, index)))
                .values
                .toList(),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: pageList.length,
            effect: WormEffect(
                dotWidth: barWidth,
                dotHeight: 3.0,
                spacing: 0,
                dotColor: defaultGrayBackground,
                activeDotColor: Colors.grey),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: const [
                Expanded(
                  child: FriendListScreen(),
                ),
                Expanded(
                  child: ChatListScreen(),
                ),
                Expanded(
                  child: SettingListScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
