// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class UserRequestStruct extends FFFirebaseStruct {
  UserRequestStruct({
    String? email,
    String? name,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _email = email,
        _name = name,
        super(firestoreUtilData);

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  static UserRequestStruct fromMap(Map<String, dynamic> data) =>
      UserRequestStruct(
        email: data['email'] as String?,
        name: data['name'] as String?,
      );

  static UserRequestStruct? maybeFromMap(dynamic data) => data is Map
      ? UserRequestStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'email': _email,
        'name': _name,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserRequestStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserRequestStruct(
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserRequestStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserRequestStruct &&
        email == other.email &&
        name == other.name;
  }

  @override
  int get hashCode => const ListEquality().hash([email, name]);
}

UserRequestStruct createUserRequestStruct({
  String? email,
  String? name,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    UserRequestStruct(
      email: email,
      name: name,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

UserRequestStruct? updateUserRequestStruct(
  UserRequestStruct? userRequest, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    userRequest
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addUserRequestStructData(
  Map<String, dynamic> firestoreData,
  UserRequestStruct? userRequest,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (userRequest == null) {
    return;
  }
  if (userRequest.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && userRequest.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final userRequestData =
      getUserRequestFirestoreData(userRequest, forFieldValue);
  final nestedData =
      userRequestData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = userRequest.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getUserRequestFirestoreData(
  UserRequestStruct? userRequest, [
  bool forFieldValue = false,
]) {
  if (userRequest == null) {
    return {};
  }
  final firestoreData = mapToFirestore(userRequest.toMap());

  // Add any Firestore field values
  userRequest.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getUserRequestListFirestoreData(
  List<UserRequestStruct>? userRequests,
) =>
    userRequests?.map((e) => getUserRequestFirestoreData(e, true)).toList() ??
    [];
