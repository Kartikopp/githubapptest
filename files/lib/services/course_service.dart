import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseService {
  static final CourseService _instance = CourseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory CourseService() {
    return _instance;
  }

  CourseService._internal();

  // Get all courses
  Future<List<CourseModel>> getAllCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();
      return snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  // Get featured courses
  Future<List<CourseModel>> getFeaturedCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .where('isFeatured', isEqualTo: true)
          .limit(5)
          .get();
      return snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching featured courses: $e');
      return [];
    }
  }

  // Get courses by category
  Future<List<CourseModel>> getCoursesByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  // Get course by ID
  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('courses').doc(courseId).get();
      if (doc.exists) {
        return CourseModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching course: $e');
      return null;
    }
  }

  // Create course (Admin)
  Future<String?> createCourse(CourseModel course) async {
    try {
      DocumentReference doc = await _firestore.collection('courses').add(course.toMap());
      return doc.id;
    } catch (e) {
      print('Error creating course: $e');
      return null;
    }
  }

  // Update course (Admin)
  Future<bool> updateCourse(String courseId, CourseModel course) async {
    try {
      await _firestore.collection('courses').doc(courseId).set(course.toMap());
      return true;
    } catch (e) {
      print('Error updating course: $e');
      return false;
    }
  }
}