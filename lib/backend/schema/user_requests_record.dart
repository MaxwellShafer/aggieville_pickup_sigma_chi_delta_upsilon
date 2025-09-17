import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserRequestsRecord extends FirestoreRecord {
  UserRequestsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _name = snapshotData['name'] as String?;
    _id = snapshotData['id'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('user_requests');

  static Stream<UserRequestsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserRequestsRecord.fromSnapshot(s));

  static Future<UserRequestsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserRequestsRecord.fromSnapshot(s));

  static UserRequestsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserRequestsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserRequestsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserRequestsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserRequestsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserRequestsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserRequestsRecordData({
  String? email,
  String? name,
  String? id,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'name': name,
      'id': id,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserRequestsRecordDocumentEquality
    implements Equality<UserRequestsRecord> {
  const UserRequestsRecordDocumentEquality();

  @override
  bool equals(UserRequestsRecord? e1, UserRequestsRecord? e2) {
    return e1?.email == e2?.email && e1?.name == e2?.name && e1?.id == e2?.id;
  }

  @override
  int hash(UserRequestsRecord? e) =>
      const ListEquality().hash([e?.email, e?.name, e?.id]);

  @override
  bool isValidKey(Object? o) => o is UserRequestsRecord;
}
