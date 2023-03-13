// import 'dart:async';

// import 'index.dart';
// import 'serializers.dart';
// import 'package:built_value/built_value.dart';

// part 'users_record.g.dart';

// abstract class UsersRecord implements Built<UsersRecord, UsersRecordBuilder> {
//   static Serializer<UsersRecord> get serializer => _$usersRecordSerializer;

//   String? get email;

//   String? get uid;

//   @BuiltValueField(wireName: 'created_time')
//   DateTime? get createdTime;

//   @BuiltValueField(wireName: 'setup_complete')
//   bool? get setupComplete;

//   DocumentReference? get sizes;

//   DocumentReference? get profile;

//   @BuiltValueField(wireName: 'phone_number')
//   String? get phoneNumber;

//   @BuiltValueField(wireName: 'photo_url')
//   String? get photoUrl;

//   @BuiltValueField(wireName: 'display_name')
//   String? get displayName;

//   @BuiltValueField(wireName: kDocumentReferenceField)
//   DocumentReference? get ffRef;
//   DocumentReference get reference => ffRef!;

//   static void _initializeBuilder(UsersRecordBuilder builder) => builder
//     ..email = ''
//     ..uid = ''
//     ..setupComplete = false
//     ..phoneNumber = ''
//     ..photoUrl = ''
//     ..displayName = '';

//   static CollectionReference get collection =>
//       FirebaseFirestore.instance.collection('users');

//   static Stream<UsersRecord> getDocument(DocumentReference ref) => ref
//       .snapshots()
//       .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

//   static Future<UsersRecord> getDocumentOnce(DocumentReference ref) => ref
//       .get()
//       .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

//   UsersRecord._();
//   factory UsersRecord([void Function(UsersRecordBuilder) updates]) =
//       _$UsersRecord;

//   static UsersRecord getDocumentFromData(
//           Map<String, dynamic> data, DocumentReference reference) =>
//       serializers.deserializeWith(serializer,
//           {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
// }

// Map<String, dynamic> createUsersRecordData({
//   String? email,
//   String? uid,
//   DateTime? createdTime,
//   bool? setupComplete,
//   DocumentReference? sizes,
//   DocumentReference? profile,
//   String? phoneNumber,
//   String? photoUrl,
//   String? displayName,
// }) {
//   final firestoreData = serializers.toFirestore(
//     UsersRecord.serializer,
//     UsersRecord(
//       (u) => u
//         ..email = email
//         ..uid = uid
//         ..createdTime = createdTime
//         ..setupComplete = setupComplete
//         ..sizes = sizes
//         ..profile = profile
//         ..phoneNumber = phoneNumber
//         ..photoUrl = photoUrl
//         ..displayName = displayName,
//     ),
//   );

//   return firestoreData;
// }
