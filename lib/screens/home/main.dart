import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../colors/default.dart';

const pageList = ["친구", "채팅", "설정"];

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: '셀프톡썰'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();

  void _updateBarIndicator(index) {
    setState(() {
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  Widget _viewPagerTitleWidget(String viewPagerTitle, int tabButtonIndex) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(viewPagerTitle),
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
                dotHeight:  3.0,
                spacing: 0,
                dotColor:  defaultGrayBackground,
                activeDotColor:  Colors.grey
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: pageList.map((page) {
                return Column(
                  children: [
                    Text(
                      page,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
