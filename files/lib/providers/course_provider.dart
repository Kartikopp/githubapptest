import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  
  List<CourseModel> _allCourses = [];
  List<CourseModel> _featuredCourses = [];
  bool _isLoading = false;

  List<CourseModel> get allCourses => _allCourses;
  List<CourseModel> get featuredCourses => _featuredCourses;
  bool get isLoading => _isLoading;

  // Fetch all courses
  Future<void> fetchAllCourses() async {
    _isLoading = true;
    notifyListeners();

    _allCourses = await _courseService.getAllCourses();
    _isLoading = false;
    notifyListeners();
  }

  // Fetch featured courses
  Future<void> fetchFeaturedCourses() async {
    _featuredCourses = await _courseService.getFeaturedCourses();
    notifyListeners();
  }

  // Get courses by category
  Future<List<CourseModel>> getCoursesByCategory(String category) async {
    return await _courseService.getCoursesByCategory(category);
  }

  // Get course by ID
  Future<CourseModel?> getCourseById(String courseId) async {
    return await _courseService.getCourseById(courseId);
  }
}