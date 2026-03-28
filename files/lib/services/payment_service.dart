import 'package:upi_india/upi_india.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  final UpiIndia _upiIndia = UpiIndia();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory PaymentService() {
    return _instance;
  }

  PaymentService._internal();

  // Initiate UPI Payment
  Future<bool> initiateUPIPayment({
    required String courseId,
    required String userId,
    required double amount,
    required String courseName,
  }) async {
    try {
      UpiResponse response = await _upiIndia.startTransaction(
        amount: amount.toStringAsFixed(2),
        receiverUpiId: "glitchxkartik@oksbi",
        receiverName: "Gupta Classes",
        transactionRef: "GUPTACLASSES_${DateTime.now().millisecondsSinceEpoch}",
        description: "Payment for $courseName",
      );

      if (response.status == UpiPaymentStatus.success) {
        // Record payment in Firestore
        await _recordPayment(
          courseId: courseId,
          userId: userId,
          amount: amount,
          status: 'success',
          transactionRef: response.transactionRef,
        );
        return true;
      } else if (response.status == UpiPaymentStatus.submitted) {
        await _recordPayment(
          courseId: courseId,
          userId: userId,
          amount: amount,
          status: 'pending',
          transactionRef: response.transactionRef,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }

  // Record payment in Firestore
  Future<void> _recordPayment({
    required String courseId,
    required String userId,
    required double amount,
    required String status,
    required String? transactionRef,
  }) async {
    try {
      await _firestore.collection('payments').add({
        'courseId': courseId,
        'userId': userId,
        'amount': amount,
        'status': status,
        'transactionRef': transactionRef,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Update user's purchased courses if payment successful
      if (status == 'success') {
        await _firestore.collection('users').doc(userId).update({
          'purchasedCourses': FieldValue.arrayUnion([courseId])
        });
      }
    } catch (e) {
      print('Error recording payment: $e');
    }
  }

  // Get payment history
  Future<List<Map<String, dynamic>>> getPaymentHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching payments: $e');
      return [];
    }
  }
}