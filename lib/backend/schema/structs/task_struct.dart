// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TaskStruct extends FFFirebaseStruct {
  TaskStruct({
    String? name,
    String? description,
    DateTime? dueDate,
    List<String>? images,
    String? location,

    /// a list of user ids assigned to this task
    List<String>? assignedUsers,
    bool? submitted,
    bool? verified,
    List<String>? submittedImages,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _description = description,
        _dueDate = dueDate,
        _images = images,
        _location = location,
        _assignedUsers = assignedUsers,
        _submitted = submitted,
        _verified = verified,
        _submittedImages = submittedImages,
        super(firestoreUtilData);

  // "Name" field.
  String? _name;
  String get name => _name ?? 'Task Name';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "Description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "DueDate" field.
  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;
  set dueDate(DateTime? val) => _dueDate = val;

  bool hasDueDate() => _dueDate != null;

  // "Images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  set images(List<String>? val) => _images = val;

  void updateImages(Function(List<String>) updateFn) {
    updateFn(_images ??= []);
  }

  bool hasImages() => _images != null;

  // "Location" field.
  String? _location;
  String get location => _location ?? '';
  set location(String? val) => _location = val;

  bool hasLocation() => _location != null;

  // "AssignedUsers" field.
  List<String>? _assignedUsers;
  List<String> get assignedUsers => _assignedUsers ?? const [];
  set assignedUsers(List<String>? val) => _assignedUsers = val;

  void updateAssignedUsers(Function(List<String>) updateFn) {
    updateFn(_assignedUsers ??= []);
  }

  bool hasAssignedUsers() => _assignedUsers != null;

  // "Submitted" field.
  bool? _submitted;
  bool get submitted => _submitted ?? false;
  set submitted(bool? val) => _submitted = val;

  bool hasSubmitted() => _submitted != null;

  // "Verified" field.
  bool? _verified;
  bool get verified => _verified ?? false;
  set verified(bool? val) => _verified = val;

  bool hasVerified() => _verified != null;

  // "SubmittedImages" field.
  List<String>? _submittedImages;
  List<String> get submittedImages => _submittedImages ?? const [];
  set submittedImages(List<String>? val) => _submittedImages = val;

  void updateSubmittedImages(Function(List<String>) updateFn) {
    updateFn(_submittedImages ??= []);
  }

  bool hasSubmittedImages() => _submittedImages != null;

  static TaskStruct fromMap(Map<String, dynamic> data) => TaskStruct(
        name: data['Name'] as String?,
        description: data['Description'] as String?,
        dueDate: data['DueDate'] as DateTime?,
        images: getDataList(data['Images']),
        location: data['Location'] as String?,
        assignedUsers: getDataList(data['AssignedUsers']),
        submitted: data['Submitted'] as bool?,
        verified: data['Verified'] as bool?,
        submittedImages: getDataList(data['SubmittedImages']),
      );

  static TaskStruct? maybeFromMap(dynamic data) =>
      data is Map ? TaskStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Name': _name,
        'Description': _description,
        'DueDate': _dueDate,
        'Images': _images,
        'Location': _location,
        'AssignedUsers': _assignedUsers,
        'Submitted': _submitted,
        'Verified': _verified,
        'SubmittedImages': _submittedImages,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Name': serializeParam(
          _name,
          ParamType.String,
        ),
        'Description': serializeParam(
          _description,
          ParamType.String,
        ),
        'DueDate': serializeParam(
          _dueDate,
          ParamType.DateTime,
        ),
        'Images': serializeParam(
          _images,
          ParamType.String,
          isList: true,
        ),
        'Location': serializeParam(
          _location,
          ParamType.String,
        ),
        'AssignedUsers': serializeParam(
          _assignedUsers,
          ParamType.String,
          isList: true,
        ),
        'Submitted': serializeParam(
          _submitted,
          ParamType.bool,
        ),
        'Verified': serializeParam(
          _verified,
          ParamType.bool,
        ),
        'SubmittedImages': serializeParam(
          _submittedImages,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static TaskStruct fromSerializableMap(Map<String, dynamic> data) =>
      TaskStruct(
        name: deserializeParam(
          data['Name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['Description'],
          ParamType.String,
          false,
        ),
        dueDate: deserializeParam(
          data['DueDate'],
          ParamType.DateTime,
          false,
        ),
        images: deserializeParam<String>(
          data['Images'],
          ParamType.String,
          true,
        ),
        location: deserializeParam(
          data['Location'],
          ParamType.String,
          false,
        ),
        assignedUsers: deserializeParam<String>(
          data['AssignedUsers'],
          ParamType.String,
          true,
        ),
        submitted: deserializeParam(
          data['Submitted'],
          ParamType.bool,
          false,
        ),
        verified: deserializeParam(
          data['Verified'],
          ParamType.bool,
          false,
        ),
        submittedImages: deserializeParam<String>(
          data['SubmittedImages'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'TaskStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TaskStruct &&
        name == other.name &&
        description == other.description &&
        dueDate == other.dueDate &&
        listEquality.equals(images, other.images) &&
        location == other.location &&
        listEquality.equals(assignedUsers, other.assignedUsers) &&
        submitted == other.submitted &&
        verified == other.verified &&
        listEquality.equals(submittedImages, other.submittedImages);
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        description,
        dueDate,
        images,
        location,
        assignedUsers,
        submitted,
        verified,
        submittedImages
      ]);
}

TaskStruct createTaskStruct({
  String? name,
  String? description,
  DateTime? dueDate,
  String? location,
  bool? submitted,
  bool? verified,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TaskStruct(
      name: name,
      description: description,
      dueDate: dueDate,
      location: location,
      submitted: submitted,
      verified: verified,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TaskStruct? updateTaskStruct(
  TaskStruct? task, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    task
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTaskStructData(
  Map<String, dynamic> firestoreData,
  TaskStruct? task,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (task == null) {
    return;
  }
  if (task.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && task.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final taskData = getTaskFirestoreData(task, forFieldValue);
  final nestedData = taskData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = task.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTaskFirestoreData(
  TaskStruct? task, [
  bool forFieldValue = false,
]) {
  if (task == null) {
    return {};
  }
  final firestoreData = mapToFirestore(task.toMap());

  // Add any Firestore field values
  task.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTaskListFirestoreData(
  List<TaskStruct>? tasks,
) =>
    tasks?.map((e) => getTaskFirestoreData(e, true)).toList() ?? [];
