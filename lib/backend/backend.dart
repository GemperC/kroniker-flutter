// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../auth/auth_util.dart';

// export 'dart:async' show StreamSubscription;
// export 'package:cloud_firestore/cloud_firestore.dart';

// /// Functions to query UsersRecords (as a Stream and as a Future).
// Future<int> queryUsersRecordCount({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
// }) =>
//     queryCollectionCount(
//       UsersRecord.collection,
//       queryBuilder: queryBuilder,
//       limit: limit,
//     );

// Stream<List<UsersRecord>> queryUsersRecord({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollection(
//       UsersRecord.collection,
//       UsersRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<List<UsersRecord>> queryUsersRecordOnce({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollectionOnce(
//       UsersRecord.collection,
//       UsersRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<FFFirestorePage<UsersRecord>> queryUsersRecordPage({
//   Query Function(Query)? queryBuilder,
//   DocumentSnapshot? nextPageMarker,
//   required int pageSize,
//   required bool isStream,
// }) =>
//     queryCollectionPage(
//       UsersRecord.collection,
//       UsersRecord.serializer,
//       queryBuilder: queryBuilder,
//       nextPageMarker: nextPageMarker,
//       pageSize: pageSize,
//       isStream: isStream,
//     );

// /// Functions to query ChatsRecords (as a Stream and as a Future).
// Future<int> queryChatsRecordCount({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
// }) =>
//     queryCollectionCount(
//       ChatsRecord.collection,
//       queryBuilder: queryBuilder,
//       limit: limit,
//     );

// Stream<List<ChatsRecord>> queryChatsRecord({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollection(
//       ChatsRecord.collection,
//       ChatsRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<List<ChatsRecord>> queryChatsRecordOnce({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollectionOnce(
//       ChatsRecord.collection,
//       ChatsRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<FFFirestorePage<ChatsRecord>> queryChatsRecordPage({
//   Query Function(Query)? queryBuilder,
//   DocumentSnapshot? nextPageMarker,
//   required int pageSize,
//   required bool isStream,
// }) =>
//     queryCollectionPage(
//       ChatsRecord.collection,
//       ChatsRecord.serializer,
//       queryBuilder: queryBuilder,
//       nextPageMarker: nextPageMarker,
//       pageSize: pageSize,
//       isStream: isStream,
//     );

// /// Functions to query SizesRecords (as a Stream and as a Future).
// Future<int> querySizesRecordCount({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
// }) =>
//     queryCollectionCount(
//       SizesRecord.collection,
//       queryBuilder: queryBuilder,
//       limit: limit,
//     );

// Stream<List<SizesRecord>> querySizesRecord({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollection(
//       SizesRecord.collection,
//       SizesRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<List<SizesRecord>> querySizesRecordOnce({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollectionOnce(
//       SizesRecord.collection,
//       SizesRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<FFFirestorePage<SizesRecord>> querySizesRecordPage({
//   Query Function(Query)? queryBuilder,
//   DocumentSnapshot? nextPageMarker,
//   required int pageSize,
//   required bool isStream,
// }) =>
//     queryCollectionPage(
//       SizesRecord.collection,
//       SizesRecord.serializer,
//       queryBuilder: queryBuilder,
//       nextPageMarker: nextPageMarker,
//       pageSize: pageSize,
//       isStream: isStream,
//     );

// /// Functions to query UserProfilesRecords (as a Stream and as a Future).
// Future<int> queryUserProfilesRecordCount({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
// }) =>
//     queryCollectionCount(
//       UserProfilesRecord.collection,
//       queryBuilder: queryBuilder,
//       limit: limit,
//     );

// Stream<List<UserProfilesRecord>> queryUserProfilesRecord({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollection(
//       UserProfilesRecord.collection,
//       UserProfilesRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<List<UserProfilesRecord>> queryUserProfilesRecordOnce({
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
//   bool singleRecord = false,
// }) =>
//     queryCollectionOnce(
//       UserProfilesRecord.collection,
//       UserProfilesRecord.serializer,
//       queryBuilder: queryBuilder,
//       limit: limit,
//       singleRecord: singleRecord,
//     );

// Future<FFFirestorePage<UserProfilesRecord>> queryUserProfilesRecordPage({
//   Query Function(Query)? queryBuilder,
//   DocumentSnapshot? nextPageMarker,
//   required int pageSize,
//   required bool isStream,
// }) =>
//     queryCollectionPage(
//       UserProfilesRecord.collection,
//       UserProfilesRecord.serializer,
//       queryBuilder: queryBuilder,
//       nextPageMarker: nextPageMarker,
//       pageSize: pageSize,
//       isStream: isStream,
//     );

// Future<int> queryCollectionCount(
//   Query collection, {
//   Query Function(Query)? queryBuilder,
//   int limit = -1,
// }) {
//   final builder = queryBuilder ?? (q) => q;
//   var query = builder(collection);
//   if (limit > 0) {
//     query = query.limit(limit);
//   }

//   return query.count().get().catchError((err) {
//     print('Error querying $collection: $err');
//   }).then((value) => value.count);
// }

// Stream<List<T>> queryCollection<T>(Query collection, Serializer<T> serializer,
//     {Query Function(Query)? queryBuilder,
//     int limit = -1,
//     bool singleRecord = false}) {
//   final builder = queryBuilder ?? (q) => q;
//   var query = builder(collection);
//   if (limit > 0 || singleRecord) {
//     query = query.limit(singleRecord ? 1 : limit);
//   }
//   return query.snapshots().handleError((err) {
//     print('Error querying $collection: $err');
//   }).map((s) => s.docs
//       .map(
//         (d) => safeGet(
//           () => serializers.deserializeWith(serializer, serializedData(d)),
//           (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
//         ),
//       )
//       .where((d) => d != null)
//       .map((d) => d!)
//       .toList());
// }

// Future<List<T>> queryCollectionOnce<T>(
//     Query collection, Serializer<T> serializer,
//     {Query Function(Query)? queryBuilder,
//     int limit = -1,
//     bool singleRecord = false}) {
//   final builder = queryBuilder ?? (q) => q;
//   var query = builder(collection);
//   if (limit > 0 || singleRecord) {
//     query = query.limit(singleRecord ? 1 : limit);
//   }
//   return query.get().then((s) => s.docs
//       .map(
//         (d) => safeGet(
//           () => serializers.deserializeWith(serializer, serializedData(d)),
//           (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
//         ),
//       )
//       .where((d) => d != null)
//       .map((d) => d!)
//       .toList());
// }

// extension QueryExtension on Query {
//   Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
//       ? where(field, whereIn: null)
//       : where(field, whereIn: list);

//   Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
//       ? where(field, whereNotIn: null)
//       : where(field, whereNotIn: list);

//   Query whereArrayContainsAny(String field, List? list) =>
//       (list?.isEmpty ?? true)
//           ? where(field, arrayContainsAny: null)
//           : where(field, arrayContainsAny: list);
// }

// class FFFirestorePage<T> {
//   final List<T> data;
//   final Stream<List<T>>? dataStream;
//   final QueryDocumentSnapshot? nextPageMarker;

//   FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
// }

// Future<FFFirestorePage<T>> queryCollectionPage<T>(
//   Query collection,
//   Serializer<T> serializer, {
//   Query Function(Query)? queryBuilder,
//   DocumentSnapshot? nextPageMarker,
//   required int pageSize,
//   required bool isStream,
// }) async {
//   final builder = queryBuilder ?? (q) => q;
//   var query = builder(collection).limit(pageSize);
//   if (nextPageMarker != null) {
//     query = query.startAfterDocument(nextPageMarker);
//   }
//   Stream<QuerySnapshot>? docSnapshotStream;
//   QuerySnapshot docSnapshot;
//   if (isStream) {
//     docSnapshotStream = query.snapshots();
//     docSnapshot = await docSnapshotStream.first;
//   } else {
//     docSnapshot = await query.get();
//   }
//   final getDocs = (QuerySnapshot s) => s.docs
//       .map(
//         (d) => safeGet(
//           () => serializers.deserializeWith(serializer, serializedData(d)),
//           (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
//         ),
//       )
//       .where((d) => d != null)
//       .map((d) => d!)
//       .toList();
//   final data = getDocs(docSnapshot);
//   final dataStream = docSnapshotStream?.map(getDocs);
//   final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
//   return FFFirestorePage(data, dataStream, nextPageToken);
// }

// // Creates a Firestore document representing the logged in user if it doesn't yet exist
// Future maybeCreateUser(User user) async {
//   final userRecord = UsersRecord.collection.doc(user.uid);
//   final userExists = await userRecord.get().then((u) => u.exists);
//   if (userExists) {
//     currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
//     return;
//   }

//   final userData = createUsersRecordData(
//     email: user.email,
//     displayName: user.displayName,
//     photoUrl: user.photoURL,
//     uid: user.uid,
//     phoneNumber: user.phoneNumber,
//     createdTime: getCurrentTimestamp,
//   );

//   await userRecord.set(userData);
//   currentUserDocument =
//       serializers.deserializeWith(UsersRecord.serializer, userData);
// }