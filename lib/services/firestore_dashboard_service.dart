import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for Firestore dashboard queries
/// All Firestore database operations are handled here
class FirestoreDashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get total count of doctors from Firestore
  Future<int> getDoctorsCount() async {
    try {
      final snapshot = await _db.collection('doctors').get();
      return snapshot.docs.length;
    } catch (e) {
      // Return 0 if there's an error (e.g., collection doesn't exist yet)
      return 0;
    }
  }

  /// Get total count of nurses from Firestore
  Future<int> getNursesCount() async {
    try {
      final snapshot = await _db.collection('nurses').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get total count of patients from Firestore
  Future<int> getPatientsCount() async {
    try {
      final snapshot = await _db.collection('patients').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get total count of posts from Firestore
  Future<int> getPostsCount() async {
    try {
      final snapshot = await _db.collection('posts').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get recent activity list from Firestore
  /// Returns a list of activity text strings (most recent first)
  Future<List<String>> getRecentActivity() async {
    try {
      final snapshot =
          await _db
              .collection('admin_recent_activity')
              .orderBy('timestamp', descending: true)
              .limit(3)
              .get();

      return snapshot.docs
          .map((doc) => doc.data()['activity'] as String? ?? '')
          .where((activity) => activity.isNotEmpty)
          .toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }
}
