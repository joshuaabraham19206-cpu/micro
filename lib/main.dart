import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// We import the new screen files we are about to create.
import 'screens/home_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/community_screen.dart';

// --- MAIN FUNCTION ---
// This is the starting point of every Flutter app.
void main() {
  runApp(const MentalHealthApp());
}

// --- APP's ROOT WIDGET ---
// This widget sets up the entire app, including the theme (colors, fonts).
class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the debug banner from the top right corner.
      debugShowCheckedModeBanner: false,
      title: 'Mental Health Support',
      // --- APP THEME ---
      // This is where we define the "look and feel" of the app, based on our design.
      theme: ThemeData(
        // The primary color palette.
        primaryColor: const Color(0xFF76B8B8), // Muted Teal
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Soft off-white
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF76B8B8), // Muted Teal
          primary: const Color(0xFF76B8B8), // Muted Teal
          secondary: const Color(0xFFD6A184), // Warm Terracotta
          brightness: Brightness.light,
        ),

        // --- TYPOGRAPHY ---
        // We use the google_fonts package to get beautiful, custom fonts.
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)
            .copyWith(
              // For headlines
              headlineSmall: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
              // For body text
              bodyMedium: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF555555),
                height: 1.5, // Generous line spacing for readability
              ),
              // For buttons
              labelLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

        // --- WIDGET THEMES ---
        // Consistent styling for common widgets.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF76B8B8), // Muted Teal
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Soft, rounded buttons
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      // The main screen of our app.
      home: const MainScreen(),
    );
  }
}

// --- MAIN SCREEN WITH NAVIGATION ---
// This is a stateful widget because we need to remember which tab is currently selected.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // This integer holds the index of the currently selected tab.
  int _selectedIndex = 0;

  // A list of all the main pages/screens for our app.
  // The widgets are now imported from their own files.
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ResourcesScreen(),
    BookingScreen(),
    CommunityScreen(),
  ];

  // This function is called when a navigation bar item is tapped.
  void _onItemTapped(int index) {
    // setState is crucial. It tells Flutter that the state has changed
    // and the UI needs to be rebuilt to reflect the change.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is the basic layout structure for a screen in Material Design.
    return Scaffold(
      // The body of the scaffold will display the currently selected page.
      body: Center(child: _pages.elementAt(_selectedIndex)),
      // The bottom navigation bar.
      bottomNavigationBar: BottomNavigationBar(
        // The list of items to display.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Community',
          ),
        ],
        // These properties ensure the navigation bar looks and feels right.
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        // This makes sure the labels are always visible.
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
