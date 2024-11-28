//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
//
// final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
// final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
// // Log upload synchronization error
// Future<void> logUploadError(String userId, String errorCode, String errorMessage, endPoint) async {
//   await analytics.logEvent(
//     name: 'sync_upload_error',
//     parameters:  {
//       'user_id': userId,
//       'error_code': errorCode,
//       'error_message': errorMessage,
//       'end_point': endPoint,
//     },
//   );
// }
//
// // Log download synchronization error
// Future<void> logDownloadError(String userId, String errorCode, String errorMessage) async {
//   await analytics.logEvent(
//     name: 'sync_download_error',
//     parameters:  {
//       'end_point'
//       'user_id': userId,
//       'error_code': errorCode,
//       'error_message': errorMessage,
//     },
//   );
// }
//
//
// Future<void> logSyncErrorToFirestore({
//   required String userId,
//   required String syncType, // 'upload' or 'download'
//   required String errorCode,
//   required String errorMessage,
// }) async {
//   await firestore.collection('sync_errors').add({
//     'user_id': userId,
//     'sync_type': syncType,
//     'error_code': errorCode,
//     'error_message': errorMessage,
//     'timestamp': FieldValue.serverTimestamp(),
//   });
// }
