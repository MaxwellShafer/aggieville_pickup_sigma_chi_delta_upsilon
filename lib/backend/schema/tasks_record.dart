import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TasksRecord extends FirestoreRecord {
  TasksRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "dueDate" field.
  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;
  bool hasDueDate() => _dueDate != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  // "location" field.
  String? _location;
  String get location => _location ?? '';
  bool hasLocation() => _location != null;

  // "assignedUsers" field.
  List<String>? _assignedUsers;
  List<String> get assignedUsers => _assignedUsers ?? const [];
  bool hasAssignedUsers() => _assignedUsers != null;

  // "submitted" field.
  bool? _submitted;
  bool get submitted => _submitted ?? false;
  bool hasSubmitted() => _submitted != null;

  // "verified" field.
  bool? _verified;
  bool get verified => _verified ?? false;
  bool hasVerified() => _verified != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _dueDate = snapshotData['dueDate'] as DateTime?;
    _images = getDataList(snapshotData['images']);
    _location = snapshotData['location'] as String?;
    _assignedUsers = getDataList(snapshotData['assignedUsers']);
    _submitted = snapshotData['submitted'] as bool?;
    _verified = snapshotData['verified'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tasks');

  static Stream<TasksRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TasksRecord.fromSnapshot(s));

  static Future<TasksRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TasksRecord.fromSnapshot(s));

  static TasksRecord fromSnapshot(DocumentSnapshot snapshot) => TasksRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TasksRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TasksRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TasksRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TasksRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTasksRecordData({
  String? name,
  String? description,
  DateTime? dueDate,
  String? location,
  bool? submitted,
  bool? verified,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'location': location,
      'submitted': submitted,
      'verified': verified,
    }.withoutNulls,
  );

  return firestoreData;
}

class TasksRecordDocumentEquality implements Equality<TasksRecord> {
  const TasksRecordDocumentEquality();

  @override
  bool equals(TasksRecord? e1, TasksRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.dueDate == e2?.dueDate &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.location == e2?.location &&
        listEquality.equals(e1?.assignedUsers, e2?.assignedUsers) &&
        e1?.submitted == e2?.submitted &&
        e1?.verified == e2?.verified;
  }

  @override
  int hash(TasksRecord? e) => const ListEquality().hash([
        e?.name,
        e?.description,
        e?.dueDate,
        e?.images,
        e?.location,
        e?.assignedUsers,
        e?.submitted,
        e?.verified
      ]);

  @override
  bool isValidKey(Object? o) => o is TasksRecord;
}
