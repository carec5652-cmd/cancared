import 'package:flutter/foundation.dart';
import '../services/firestore_dashboard_service.dart';

/// Controller for Admin Dashboard
/// Manages dashboard state and calls service methods to load data
class AdminDashboardController extends ChangeNotifier {
  final FirestoreDashboardService service;

  // Dashboard counts
  int doctorsCount = 0;
  int nursesCount = 0;
  int patientsCount = 0;
  int postsCount = 0;

  // Loading state
  bool isLoading = false;

  // Recent activity list
  List<String> recentActivity = [];

  // Constructor - inject the service
  AdminDashboardController({FirestoreDashboardService? service})
    : service = service ?? FirestoreDashboardService();

  /// Load all dashboard data from Firestore
  /// Sets isLoading to true, fetches data, then updates state
  Future<void> loadDashboardData() async {
    isLoading = true;
    notifyListeners(); // Notify UI that loading started

    try {
      // Load all counts in parallel for better performance
      final results = await Future.wait([
        service.getDoctorsCount(),
        service.getNursesCount(),
        service.getPatientsCount(),
        service.getPostsCount(),
        service.getRecentActivity(),
      ]);

      // Update state with fetched data
      doctorsCount = results[0] as int;
      nursesCount = results[1] as int;
      patientsCount = results[2] as int;
      postsCount = results[3] as int;
      recentActivity = results[4] as List<String>;
    } catch (e) {
      // If error occurs, keep default values (0 and empty list)
      // In production, you might want to show an error message
      if (kDebugMode) {
        print('Error loading dashboard data: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI that loading finished
    }
  }
}
