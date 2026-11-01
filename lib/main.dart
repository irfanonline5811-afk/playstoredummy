
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const MyApp());
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyScrollBehavior(),
      title: 'Playstore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const PlayStoreHome(),
    );
  }
}

// GAME CARD: IMAGE UPAR, NAME AUR RATING NEECHE
Widget _gameCard(BuildContext context, String name, String imagePath) {
  return GestureDetector(
    onTap: () {
      _openAppDetail(
        context,
        name: name,
        imagePath: imagePath,
        category: 'Game',
        rating: '4.5',
        size: '85 MB',
        downloads: '50M+',
      );
    },
    child: SizedBox(
      width: 125,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                height: 100,
                width: 125,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 3),
            const Text(
              '★ 4.5',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _openAppDetail(
  BuildContext context, {
  required String name,
  required String imagePath,
  String category = 'App',
  String rating = '4.5',
  String size = '45 MB',
  String downloads = '100M+',
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AppDetailPage(
        name: name,
        imagePath: imagePath,
        category: category,
        rating: rating,
        size: size,
        downloads: downloads,
      ),
    ),
  );
}


class PlayStoreHome extends StatefulWidget {
  const PlayStoreHome({super.key});

  @override
  State<PlayStoreHome> createState() => _PlayStoreHomeState();
}

class _PlayStoreHomeState extends State<PlayStoreHome> {
  int selectedIndex = 0;
  String selectedCategory = 'Game';

  void openCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Widget _categoryButtons() {
    return SizedBox(
      height: 55,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {
                openCategory('Game');
              },
              child: const Text('Game'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () async {
                final result = await showMenu<String>(
                  context: context,
                  position: const RelativeRect.fromLTRB(
                    100,
                    100,
                    100,
                    100,
                  ),
                  items: const [
                    PopupMenuItem(
                      value: 'Top Free',
                      child: Text('Top Free'),
                    ),
                    PopupMenuItem(
                      value: 'Top Grossing',
                      child: Text('Top Grossing'),
                    ),
                    PopupMenuItem(
                      value: 'Top Paid',
                      child: Text('Top Paid'),
                    ),
                  ],
                );

                if (result != null) {
                  setState(() {
                    selectedCategory = result;
                  });
                }
              },
              child: const Text('Top Charts'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                openCategory('Premium');
              },
              child: const Text('Premium'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                openCategory('Kids');
              },
              child: const Text('Kids'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                openCategory('Categories');
              },
              child: const Text('Categories'),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        key: ValueKey(selectedIndex),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              title: Text(
                selectedIndex == 0
                    ? 'playstore'
                    : selectedIndex == 1
                    ? 'Apps'
                    : 'Profile',
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
              ],
              bottom: selectedIndex == 0
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(55),
                      child: _categoryButtons(),
                    )
                  : null,
            ),
          ];
        },
        body: selectedIndex == 1
            ? const AppsPage()
            : selectedIndex == 2
            ? const ProfilePage(showAppBar: false)
            : (selectedCategory == 'Game'
                ? gameHome()
                : categoryPage(selectedCategory)),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;

            if (index == 0) {
              selectedCategory = 'Game';
            }
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'App',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // GAME HOME
  Widget gameHome() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // SWIPEABLE BANNERS WITH MATCHING APP UNDERNEATH (SCROLL TOGETHER)
        SizedBox(
          height: 232,
          child: PageView(
            children: [
              _banner(
                context,
                bannerImage: 'assets/banner1.png',
                badgeText: 'Update available',
                bannerTitle: 'Gaming Zone: Live Arena',
                bannerDescription: 'twitch.com/username • Watch top gaming streams',
                appIcon: 'assets/games/game2.png',
                appName: 'PUBG MOBILE',
                appCategory: 'Level Infinite',
                appRating: '4.5',
                ageRating: '16+',
                badgeBgColor: const Color(0xFFEADBFF),
                badgeTextColor: const Color(0xFF381E72),
              ),
              _banner(
                context,
                bannerImage: 'assets/banner2.png',
                badgeText: 'Special offer',
                bannerTitle: 'New City Car For Sale',
                bannerDescription: 'Sale 70% Off • Explore top car specifications',
                appIcon: 'assets/games/game5.png',
                appName: 'City Racing: Real Car 3D',
                appCategory: 'Turbo Games',
                appRating: '4.6',
                ageRating: '3+',
                badgeBgColor: const Color(0xFFFFE2DD),
                badgeTextColor: const Color(0xFFB3261E),
              ),
              _banner(
                context,
                bannerImage: 'assets/banner3.png',
                badgeText: 'Limited offer',
                bannerTitle: 'Black Friday Super Sale',
                bannerDescription: 'Get up to 50% discount on luxury car deals',
                appIcon: 'assets/games/game8.png',
                appName: 'Drive Elite: Supercars',
                appCategory: 'Apex Motors',
                appRating: '4.4',
                ageRating: '7+',
                badgeBgColor: const Color(0xFFFFECB3),
                badgeTextColor: const Color(0xFFE65100),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(
                  'Popular Games',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // POPULAR GAMES
              SizedBox(
                height: 175,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _gameCard(context, 'Free Fire', 'assets/games/game1.png'),
                    _gameCard(context, 'PUBG Mobile', 'assets/games/game2.png'),
                    _gameCard(context, 'Call of Duty', 'assets/games/game3.png'),
                    _gameCard(context, 'Subway Surfers', 'assets/games/game4.png'),
                    _gameCard(context, 'Temple Run 2', 'assets/games/game5.png'),
                    _gameCard(context, 'Clash of Clans', 'assets/games/game6.png'),
                    _gameCard(context, 'Candy Crush', 'assets/games/game7.png'),
                    _gameCard(context, 'Minecraft', 'assets/games/game8.png'),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Popular Apps',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'WhatsApp',
                  imagePath: 'assets/apps/app1.png',
                  category: 'Communication',
                  rating: '4.5',
                  size: '35 MB',
                  downloads: '5B+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/apps/app1.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('WhatsApp'),
                subtitle: const Text('Communication • ⭐ 4.5'),
                trailing: const Icon(Icons.download),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'YouTube',
                  imagePath: 'assets/apps/app2.png',
                  category: 'Video',
                  rating: '4.4',
                  size: '52 MB',
                  downloads: '10B+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/apps/app2.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('YouTube'),
                subtitle: const Text('Video • ⭐ 4.4'),
                trailing: const Icon(Icons.download),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'Music App',
                  imagePath: 'assets/apps/app3.png',
                  category: 'Music',
                  rating: '4.3',
                  size: '28 MB',
                  downloads: '100M+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/apps/app3.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Music App'),
                subtitle: const Text('Music • ⭐ 4.3'),
                trailing: const Icon(Icons.download),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'Photo Editor',
                  imagePath: 'assets/apps/app4.png',
                  category: 'Photography',
                  rating: '4.2',
                  size: '40 MB',
                  downloads: '50M+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/apps/app4.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Photo Editor'),
                subtitle: const Text('Photography • ⭐ 4.2'),
                trailing: const Icon(Icons.download),
              ),

              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Recommended for You',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'Racing Game',
                  imagePath: 'assets/games/game5.png',
                  category: 'Racing',
                  rating: '4.6',
                  size: '60 MB',
                  downloads: '100M+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/games/game5.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Racing Game'),
                subtitle: const Text('Recommended • ⭐ 4.6'),
                trailing: const Icon(Icons.download),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'Puzzle Game',
                  imagePath: 'assets/games/game6.png',
                  category: 'Puzzle',
                  rating: '4.3',
                  size: '45 MB',
                  downloads: '50M+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/games/game6.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Puzzle Game'),
                subtitle: const Text('Recommended • ⭐ 4.3'),
                trailing: const Icon(Icons.download),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'New Adventure',
                  imagePath: 'assets/games/game7.png',
                  category: 'Adventure',
                  rating: '4.4',
                  size: '90 MB',
                  downloads: '10M+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/games/game7.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('New Adventure'),
                subtitle: const Text('Suggested game • ⭐ 4.4'),
                trailing: const Icon(Icons.download),
              ),

              ListTile(
                onTap: () => _openAppDetail(
                  context,
                  name: 'Featured Offer',
                  imagePath: 'assets/games/game8.png',
                  category: 'Game',
                  rating: '4.5',
                  size: '120 MB',
                  downloads: '20M+',
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/games/game8.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text('Featured Offer'),
                subtitle: const Text('Sponsored recommendation • Ad'),
                trailing: const Icon(Icons.arrow_forward),
              ),

              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Offline Games',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: 175,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _gameCard(context, 'Hill Climb Racing', 'assets/games/game9.png'),
                    _gameCard(context, 'Plants vs. Zombies 2', 'assets/games/game10.png'),
                    _gameCard(context, 'Balatro', 'assets/games/game11.png'),
                    _gameCard(context, 'Mini Metro', 'assets/games/game12.png'),
                    _gameCard(context, "Baldur's Gate III", 'assets/games/game13.png'),
                    _gameCard(context, 'Dead Cells', 'assets/games/game14.png'),
                    _gameCard(context, 'Table Tennis', 'assets/games/game15.png'),
                    _gameCard(context, 'Stardew Valley', 'assets/games/game16.png'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
      ],
    );
  }

  // CATEGORY PAGES
  Widget categoryPage(String category) {
    List<Map<String, String>> items = [];

    if (category == 'Top Free') {
      items = [
        {'name': 'Free Fire', 'image': 'assets/categories/games/free_fire.png'},
        {'name': 'Subway Surfers', 'image': 'assets/categories/games/subway_surfers.png'},
        {'name': 'WhatsApp', 'image': 'assets/categories/apps/whatsapp.png'},
        {'name': 'YouTube', 'image': 'assets/categories/apps/youtube.png'},
        {'name': 'Candy Crush', 'image': 'assets/categories/games/puzzle_games.png'},
      ];
    } else if (category == 'Top Grossing') {
      items = [
        {'name': 'PUBG Mobile', 'image': 'assets/categories/games/pubg_mobile.png'},
        {'name': 'Roblox', 'image': 'assets/categories/games/adventure_games.png'},
        {'name': 'Call of Duty', 'image': 'assets/categories/games/action_games.png'},
        {'name': 'Clash of Clans', 'image': 'assets/categories/games/puzzle_games.png'},
      ];
    } else if (category == 'Top Paid') {
      items = [
        {'name': 'Minecraft', 'image': 'assets/categories/premium/minecraft.png'},
        {'name': 'Premium Racing', 'image': 'assets/categories/premium/premium_racing.png'},
        {'name': 'Puzzle Pro', 'image': 'assets/categories/premium/puzzle_pro.png'},
        {'name': 'Adventure Pro', 'image': 'assets/categories/premium/adventure_pro.png'},
      ];
    } else if (category == 'Premium') {
      items = [
        {'name': 'Premium Racing', 'image': 'assets/categories/premium/premium_racing.png'},
        {'name': 'Minecraft', 'image': 'assets/categories/premium/minecraft.png'},
        {'name': 'Puzzle Pro', 'image': 'assets/categories/premium/puzzle_pro.png'},
        {'name': 'Adventure Pro', 'image': 'assets/categories/premium/adventure_pro.png'},
      ];
    } else if (category == 'Kids') {
      items = [
        {'name': 'Kids Learning', 'image': 'assets/categories/kids/kids_learning.png'},
        {'name': 'Coloring Book', 'image': 'assets/categories/kids/coloring_book.png'},
        {'name': 'Kids Puzzle', 'image': 'assets/categories/kids/kids_puzzle.png'},
        {'name': 'Math for Kids', 'image': 'assets/categories/kids/math_for_kids.png'},
        {'name': 'Drawing for Kids', 'image': 'assets/categories/kids/drawing_for_kids.png'},
      ];
    } else if (category == 'Categories') {
      items = [
        {'name': 'Action Games', 'image': 'assets/categories/categories/action_games.png'},
        {'name': 'Adventure Games', 'image': 'assets/categories/categories/adventure_games.png'},
        {'name': 'Puzzle Games', 'image': 'assets/categories/categories/puzzle_games.png'},
        {'name': 'Racing Games', 'image': 'assets/categories/categories/racing_games.png'},
        {'name': 'Education Apps', 'image': 'assets/categories/categories/education_apps.png'},
        {'name': 'Music Apps', 'image': 'assets/categories/categories/music_apps.png'},
        {'name': 'Photography Apps', 'image': 'assets/categories/categories/photography_apps.png'},
        {'name': 'Sports Games', 'image': 'assets/categories/categories/sports_games.png'},
      ];
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        for (int i = 0; i < items.length; i++)
          ListTile(
            onTap: () {
              _openAppDetail(
                context,
                name: items[i]['name']!,
                imagePath: items[i]['image']!,
                category: category,
                rating: '4.${(i % 5) + 1}',
                size: '${40 + (i * 10)} MB',
                downloads: '${10 * (i + 1)}M+',
              );
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                items[i]['image']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(items[i]['name']!),
            subtitle: Text(
              category == 'Categories'
                  ? 'Explore ${items[i]['name']}'
                  : '⭐ 4.${(i % 5) + 1} • $category',
            ),
            trailing: const Icon(Icons.arrow_forward),
          ),
      ],
    );
  }
}

// APPS PAGE
class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apps = [
      {'name': 'WhatsApp', 'image': 'assets/apps/app9.png', 'cat': 'Communication', 'rating': '4.5', 'size': '35 MB', 'downloads': '5B+'},
      {'name': 'YouTube', 'image': 'assets/apps/app10.png', 'cat': 'Video', 'rating': '4.4', 'size': '52 MB', 'downloads': '10B+'},
      {'name': 'Spotify', 'image': 'assets/apps/app11.png', 'cat': 'Music', 'rating': '4.3', 'size': '28 MB', 'downloads': '1B+'},
      {'name': 'Photo Editor', 'image': 'assets/apps/app12.png', 'cat': 'Photography', 'rating': '4.2', 'size': '40 MB', 'downloads': '100M+'},
      {'name': 'Maps', 'image': 'assets/apps/app13.png', 'cat': 'Navigation', 'rating': '4.6', 'size': '65 MB', 'downloads': '5B+'},
      {'name': 'Shopping App', 'image': 'assets/apps/app14.png', 'cat': 'Shopping', 'rating': '4.1', 'size': '30 MB', 'downloads': '50M+'},
      {'name': 'Learning App', 'image': 'assets/apps/app15.png', 'cat': 'Education', 'rating': '4.5', 'size': '45 MB', 'downloads': '20M+'},
      {'name': 'Food Delivery', 'image': 'assets/apps/app16.png', 'cat': 'Food', 'rating': '4.2', 'size': '55 MB', 'downloads': '50M+'},
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return ListTile(
          onTap: () {
            _openAppDetail(
              context,
              name: app['name']!,
              imagePath: app['image']!,
              category: app['cat']!,
              rating: app['rating']!,
              size: app['size']!,
              downloads: app['downloads']!,
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              app['image']!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(app['name']!),
          subtitle: Text('${app['cat']} • ⭐ ${app['rating']}'),
          trailing: const Icon(Icons.download),
        );
      },
    );
  }
}

// PROFILE PAGE
class ProfilePage extends StatelessWidget {
  final bool showAppBar;
  const ProfilePage({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: EdgeInsets.zero,
      children: const [
        SizedBox(height: 25),
        Center(
          child: CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 50),
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: Text(
            'User Name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(child: Text('user@gmail.com')),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.download),
          title: Text('My Apps & Games'),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help & Support'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ],
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          backgroundColor: Colors.blue,
        ),
        body: body,
      );
    }
    return body;
  }
}

// BANNER ITEM (IMAGE ON TOP, APP DETAILS BELOW - SCROLL TOGETHER)
Widget _banner(
  BuildContext context, {
  required String bannerImage,
  required String badgeText,
  required String bannerTitle,
  required String bannerDescription,
  required String appIcon,
  required String appName,
  required String appCategory,
  required String appRating,
  required String ageRating,
  Color badgeBgColor = const Color(0xFFEADBFF),
  Color badgeTextColor = const Color(0xFF381E72),
  VoidCallback? onInstall,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. BANNER IMAGE WITH BADGE & PROMO TEXT OVERLAY
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 155,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Banner Image
                Image.asset(
                  bannerImage,
                  fit: BoxFit.cover,
                ),

                // Top-Left Badge (e.g. "Update available")
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Bottom Gradient Overlay for Title & Description
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          bannerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          bannerDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11.5,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 2. APP ROW DIRECTLY BENEATH BANNER
        GestureDetector(
          onTap: () {
            _openAppDetail(
              context,
              name: appName,
              imagePath: appIcon,
              category: appCategory,
              rating: appRating,
              size: '75 MB',
              downloads: '50M+',
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  appIcon,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              // App Name & Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            appCategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        // Age Rating Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 0.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade600,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            ageRating,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // Star Rating Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appRating,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.star,
                                size: 10,
                                color: Color(0xFF0B57D0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Install Button & Caption
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onInstall ??
                        () {
                          _openAppDetail(
                            context,
                            name: appName,
                            imagePath: appIcon,
                            category: appCategory,
                            rating: appRating,
                            size: '75 MB',
                            downloads: '50M+',
                          );
                        },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B57D0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Install',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'In-app purchases',
                    style: TextStyle(
                      fontSize: 8.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// APP DETAIL PAGE WITH INSTALL ACTION
class AppDetailPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final String category;
  final String rating;
  final String downloads;
  final String size;

  const AppDetailPage({
    super.key,
    required this.name,
    required this.imagePath,
    this.category = 'Application',
    this.rating = '4.5',
    this.downloads = '100M+',
    this.size = '45 MB',
  });

  @override
  State<AppDetailPage> createState() => _AppDetailPageState();
}

class _AppDetailPageState extends State<AppDetailPage> {
  bool _isDownloading = false;
  bool _isInstalled = false;
  double _progress = 0.0;

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() {
        _progress = i / 10;
      });
    }

    if (!mounted) return;
    setState(() {
      _isDownloading = false;
      _isInstalled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.name} successfully installed!'),
        backgroundColor: const Color(0xFF01875F),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cancelDownload() {
    setState(() {
      _isDownloading = false;
      _progress = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Installation cancelled'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(widget.imagePath, width: 32, height: 32, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Text('${widget.name} is running now!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _uninstallApp() {
    setState(() {
      _isInstalled = false;
      _progress = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.name} has been uninstalled'),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: ICON, NAME, DEVELOPER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      widget.imagePath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.category} • Official App',
                          style: const TextStyle(
                            color: Color(0xFF01875F),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Contains ads • In-app purchases',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // STATS ROW: RATING, SIZE, RATED, DOWNLOADS
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem(
                      '${widget.rating} ★',
                      '120K reviews',
                    ),
                    _divider(),
                    _statItem(
                      widget.size,
                      'Size',
                    ),
                    _divider(),
                    _statItem(
                      '3+',
                      'Rated for 3+',
                    ),
                    _divider(),
                    _statItem(
                      widget.downloads,
                      'Downloads',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // INSTALL / PROGRESS / OPEN BUTTON
              if (_isDownloading)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Installing... ${(_progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF01875F),
                          ),
                        ),
                        TextButton(
                          onPressed: _cancelDownload,
                          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF01875F),
                        ),
                      ),
                    ),
                  ],
                )
              else if (_isInstalled)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _uninstallApp,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text(
                          'Uninstall',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _openApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01875F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Open',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startDownload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01875F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Install',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 25),

              // SCREENSHOTS PREVIEW CAROUSEL
              const Text(
                'Screenshots',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _screenshotCard(widget.imagePath),
                    _screenshotCard(widget.imagePath),
                    _screenshotCard(widget.imagePath),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ABOUT THIS APP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'About this app',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Experience the best of ${widget.name}. Discover advanced features, smooth design, and regular updates tailored to make your digital life easier and more fun.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 15),

              // TAGS
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(widget.category),
                    backgroundColor: Colors.grey.shade100,
                  ),
                  Chip(
                    label: const Text('Top Free'),
                    backgroundColor: Colors.grey.shade100,
                  ),
                  Chip(
                    label: const Text('Editors Choice'),
                    backgroundColor: Colors.grey.shade100,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // RATINGS & REVIEWS PREVIEW
              const Text(
                'Ratings and reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    widget.rating,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star, color: Color(0xFF01875F), size: 18),
                          Icon(Icons.star, color: Color(0xFF01875F), size: 18),
                          Icon(Icons.star, color: Color(0xFF01875F), size: 18),
                          Icon(Icons.star, color: Color(0xFF01875F), size: 18),
                          Icon(Icons.star_half, color: Color(0xFF01875F), size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '120,450 reviews',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 25,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _screenshotCard(String imgPath) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imgPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}