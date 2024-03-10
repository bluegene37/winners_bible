import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io' show Platform;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:winners_bible/page/bible_page.dart';
import 'package:winners_bible/page/books_page.dart';
import 'package:winners_bible/page/chapter_page.dart';
import 'package:winners_bible/page/contacts.dart';
import 'package:winners_bible/page/more.dart';
import 'package:winners_bible/page/search_page.dart';
import 'package:winners_bible/service/ad_mob_service.dart';
import 'package:winners_bible/widgets/widgets.dart';

var box = Hive.box('settingsDB');
var hiLightBox = Hive.box('hiLightDB');
var historyBox = Hive.box('searchHistoryDB');
var notesBox = Hive.box('notesBoxDB');
var textsBox = Hive.box('textsBoxDB');

var pages = [].obs;
var mainBooks = '';
var mainBooksMenu = '';
var bibleVersions = 'kjv';
var barTitle = 'SPIN Bible'.obs;
var bookSelectedHist = '';
var bookSelected = 'Genesis';
int selectedChapterHist = 0;
int selectedChapter = 1;
int lastChapter = 1;
var searchResultHist = '';
var searchQueryMain = ''.obs;
var shouldShowLeft = true;
var shouldShowRight = true;
var themeMode = false.obs;
var globalIndex = 2.obs;
var colorIndex = 999;
var textColorIdx = 1.obs;
var colorSliderIdx = 0.obs;
var globalFont = 'Roboto'.obs;
var globalFontIdx = 9;
var fontSize = 2.0.obs;
var chaptersScreen = [];
var bibleScreen = [];
var searchScreen = [];
var textColorDynamic = Colors.black.obs;
var brightness = ThemeData.estimateBrightnessForColor(themeColors[colorSliderIdx.value]);
var statusBarChanged = false;
var textUnderline = [].obs;
var hideFloatingBtn = false.obs;
var refreshChapter = false;
var showAdds = true.obs;
var showAddsTime = 10.obs;
var loginpage = false.obs;
var loggedIn = false;
var userName = '';
var accessToken = '';
var profileIMG = '';
var appBarSize = 35.0.obs;
var users = {
  'test@gmail.com': '12345',
};
var searchTexts = TextEditingController();
String appName = '';
String packageName = '';
String version = '';
String buildNumber = '';

var globalTextColors = const [
  Colors.white,
  Colors.black
];

var themeColors = const [
  Colors.white,
  Colors.black,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurpleAccent,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  // Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

var themeColorShades = [
  Colors.grey.shade300,
  Colors.grey,
  Colors.red.shade100,
  Colors.pink.shade100,
  Colors.purple.shade100,
  Colors.deepPurpleAccent.shade100,
  Colors.indigo.shade100,
  Colors.blue.shade100,
  Colors.lightBlue.shade100,
  Colors.cyan.shade100,
  Colors.teal.shade100,
  Colors.green.shade100,
  Colors.lightGreen.shade100,
  Colors.lime.shade100,
  // Colors.yellow.shade100,
  Colors.amber.shade100,
  Colors.orange.shade100,
  Colors.deepOrange.shade100,
  Colors.brown.shade100,
  Colors.grey.shade100,
  Colors.blueGrey.shade100,
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform
  // );
  await Supabase.initialize(
    url: 'https://ldxpighnylfzrnuzbotp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxkeHBpZ2hueWxmenJudXpib3RwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5NzYwNjYwNCwiZXhwIjoyMDEzMTgyNjA0fQ.Z2Cojylt96RwTLCPSGuGDUII5im5HOzRFJQDufqYDcs',
  );
  await Hive.initFlutter();
  await Hive.openBox("settingsDB");
  await Hive.openBox("hiLightDB");
  await Hive.openBox("searchHistoryDB");
  await Hive.openBox("notesBoxDB");
  await Hive.openBox("textsBoxDB");

  // box.clear();
  // hiLightBox.clear();
  // historyBox.clear();
  // notesBox.clear();
  // textsBox.clear();

  themeMode.value = box.get('themeMode',defaultValue:false);
  bibleVersions = box.get('bibleVersions',defaultValue: 'kjv');
  bookSelected = box.get('bookSelected',defaultValue: 'Genesis');
  selectedChapter = box.get('selectedChapter',defaultValue: 1);
  colorSliderIdx.value = box.get('colorSliderIdx',defaultValue: 8);
  textColorIdx.value = box.get('textColorIdx',defaultValue: 1);
  globalFont.value = box.get('globalFont',defaultValue:'Raleway');
  globalFontIdx = box.get('globalFontIdx',defaultValue: 8);
  fontSize.value = box.get('fontSize',defaultValue: 2.0);
  loggedIn = box.get('loggedIn',defaultValue: false);
  userName = box.get('userName',defaultValue: 'John Doe');
  profileIMG = box.get('profileIMG',defaultValue: 'https://picsum.photos/200/300');
  showAdds.value = true;

  brightness = ThemeData.estimateBrightnessForColor(themeColors[colorSliderIdx.value]);
  textColorDynamic.value = brightness == Brightness.light ? Colors.black : Colors.white;

  pages.value = [BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0)];

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
          primaryColor: themeColors[colorSliderIdx.value],
          fontFamily: globalFont.value,
        ),
        dark: ThemeData(
          useMaterial3: false,
          brightness: Brightness.dark,
          primaryColor: themeColors[colorSliderIdx.value],
          fontFamily: globalFont.value,
        ),
        initial: themeMode.value ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: const MyHomePage(
            title:'SPIN Bible',
          ),
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  BannerAd? _bannerAd;

  @override
  void initState(){
    super.initState();
    _createBannerAd();
    init();
  }

  Future<void> _createBannerAd() async {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdmobService.bannerAddUnitID!,
        listener: AdmobService.bannerAdListener,
        request: const AdRequest()
    )..load();
  }

  Future init() async {
    barTitle.value = '$bookSelected $selectedChapter';
    Timer.periodic(const Duration(seconds: 2), (timer) {
      showAddsTime.value--;
      if (showAddsTime.value == 0) {
        timer.cancel();
      }
    });
  }

  void onTabTapped(index) {
    setState(() {
      globalIndex.value = index;
      loginpage.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(appBarSize.value),
        child: Obx(() => AppBar(
              centerTitle: true,
              backgroundColor: themeColors[colorSliderIdx.value],
              leading: Visibility(
                visible: globalIndex.value == 5 && (barTitle.value == "Highlights" || barTitle.value == "Settings"),
                  child: TextButton.icon(     // <-- TextButtons
                    onPressed: () {
                      barTitle.value = "More";
                      pages[0] = const MoreMenu();
                    },
                    icon: Icon(
                      Icons.navigate_before_rounded,
                      color: textColorDynamic.value,
                      size: 20.0,
                    ),
                    label: Text('',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: textColorDynamic.value,)),
                  ),
              ),
              title: Text(barTitle.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: textColorDynamic.value,),),
              // bottom: PreferredSize(
              //     preferredSize: Size.zero,
              //     child: Visibility(
              //       visible: globalIndex.value == 4,
              //         child: Text("Secure the Philippines Initiative Network", style: TextStyle(color: textColorDynamic.value,),)
              //     )
              // ),
          )
        )
      ),
      key: _key,
      body: SafeArea(child: pages[0]),
      floatingActionButtonLocation: globalIndex.value == 2 ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat ,
      floatingActionButton:
        globalIndex.value == 4
          ?
        Visibility(
          visible: false,
            child: FloatingActionButton(
              backgroundColor: themeColors[colorSliderIdx.value],
              onPressed: () {
                showBottomSheetCreate(context);
              },
              child: const Icon(Icons.add),
            )
        )
          :
        globalIndex.value == 2 && !hideFloatingBtn.value && textUnderline.isEmpty
            ?
        floatingNextPage()
            :
        null,
      bottomNavigationBar:
        // SizedBox(
        //   height: (_bannerAd != null && showAdds.value) ? Platform.isAndroid ? 120 : 160 : Platform.isAndroid ? 60 : 94,
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
              // Obx(() => Visibility(
              //   visible: _bannerAd != null && showAdds.value,
              //     child:  SizedBox(
              //       height: 60,
              //       child: Row(
              //         children: [
              //           Flexible(
              //             child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : const Text('No Ads'),
              //           ),
              //         ]
              //       )
              //     ),
              //   ),
              // ),
              navigationBar(),
        //     ],
        //   )
        // )
      )
    );
  }

  Widget navigationBar(){
    return NavigationBarTheme(
      data: NavigationBarThemeData(
          indicatorColor: themeColorShades[colorSliderIdx.value],
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          )
      ),
      child: NavigationBar(
        height: 60,
        selectedIndex: globalIndex.value,
        onDestinationSelected: (globalIndex) => {
          onTabTapped(globalIndex),
          if (globalIndex == 0) {
            barTitle.value = "Books (66)",
            appBarSize.value = 40.0,
            if(pages.toString().contains('BooksSelectionPage')){
            }else {
              pages[0] = const BooksSelectionPage()
            },
          } else if (globalIndex == 1) {
            barTitle.value = "Chapters",
            appBarSize.value = 40.0,
            if(pages.toString().contains('ChapterSelectionPage')){
            }else {
              pages[0] = const ChapterSelectionPage()
            }
          } else if (globalIndex == 2) {
            appBarSize.value = 35.0,
            if(pages.toString().contains('BooksLocalPage')){
            }else{
              pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter, 0),
            },
            barTitle.value = '$bookSelected $selectedChapter',
            colorIndex = 999
          } else if (globalIndex == 3) {
            barTitle.value = "Search",
            appBarSize.value = 40.0,
            if(pages.toString().contains('SearchLocalPage')){
            }else {
              pages[0] = const SearchLocalPage()
            }
          // } else if (globalIndex == 4) {
          //   // barTitle.value = "Notes | Highlights",
          //   barTitle.value = "Highlights",
          //   if(pages.toString().contains('NotesHLScreen')){
          //   }else {
          //     searchTexts.text = '',
          //     pages[0] = const NotesHLScreen()
          //   }
          // } else if (globalIndex == 4) {
          //   barTitle.value = "Key Partners",
          //   appBarSize.value = 50,
          //   if(pages.toString().contains('ContactPage')){
          //   }else {
          //     pages[0] = const ContactPage()
          //   }
          } else if (globalIndex == 4) {
            barTitle.value = "More",
            appBarSize.value = 40.0,
            if(pages.toString().contains('MoreMenu')){
            }else {
              pages[0] = const MoreMenu()
            }
          } else {
            pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter,0),
          },
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Books'
          ),
          NavigationDestination(
              icon: Icon(Icons.library_books_outlined),
              label: 'Chapters'
          ),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              label: 'Bible'
          ),
          NavigationDestination(
              icon: Icon(Icons.search),
              label: 'Search'
          ),
          // NavigationDestination(
          //     icon: Icon(Icons.edit_note_sharp),
          //     label: 'HL'
          // ),
          // NavigationDestination(
          //     icon: Icon(Icons.book_outlined),
          //     label: 'Contacts'
          // ),
          // NavigationDestination(
          //     icon: Icon(Icons.settings_outlined),
          //     label: 'Settings'
          // ),
          NavigationDestination(
              icon: Icon(Icons.menu_rounded),
              label: 'More'
          ),
        ],
      ),
    );
  }
}


Widget floatingNextPage(){
  return Stack(
    fit: StackFit.expand,
    children: [
      Positioned(
        left: 30,
        bottom: 20,
        width: 40,
        height: 40,
        child: FloatingActionButton(
          backgroundColor:  themeColors[colorSliderIdx.value],
          heroTag: 'back',
          onPressed: () {
            if( selectedChapter != 1){
              selectedChapter =  selectedChapter > 1 ? selectedChapter - 1 : 1;
              pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter,0);
              colorIndex = 999;
            }
          },
          child: Icon(Icons.navigate_before_rounded, size: 40, color:  selectedChapter == 1 ? Colors.black12 : textColorDynamic.value,),
        ),
      ),
      Positioned(
        right: 30,
        bottom: 20,
        width: 40,
        height: 40,
        child: FloatingActionButton(
          backgroundColor: themeColors[colorSliderIdx.value],
          heroTag: 'next',
          onPressed: () {
            if(selectedChapter != lastChapter){
              selectedChapter =  selectedChapter < lastChapter ? selectedChapter + 1 : lastChapter;
              pages[0] = BooksLocalPage(bibleVersions, bookSelected, selectedChapter,0);
              colorIndex = 999;
            }
          },
          child: Icon(Icons.navigate_next_rounded, size: 40, color:  selectedChapter == lastChapter ? Colors.black12 : textColorDynamic.value,),
        ),
      ),
    ],
  );
}

