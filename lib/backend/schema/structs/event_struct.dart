// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EventStruct extends FFFirebaseStruct {
  EventStruct({
    String? name,
    String? description,
    String? image,
    DateTime? eventDate,
    String? link,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _description = description,
        _image = image,
        _eventDate = eventDate,
        _link = link,
        super(firestoreUtilData);

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "Description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "Image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "EventDate" field.
  DateTime? _eventDate;
  DateTime? get eventDate => _eventDate;
  set eventDate(DateTime? val) => _eventDate = val;

  bool hasEventDate() => _eventDate != null;

  // "Link" field.
  String? _link;
  String get link => _link ?? '';
  set link(String? val) => _link = val;

  bool hasLink() => _link != null;

  static EventStruct fromMap(Map<String, dynamic> data) => EventStruct(
        name: data['Name'] as String?,
        description: data['Description'] as String?,
        image: data['Image'] as String?,
        eventDate: data['EventDate'] as DateTime?,
        link: data['Link'] as String?,
      );

  static EventStruct? maybeFromMap(dynamic data) =>
      data is Map ? EventStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Name': _name,
        'Description': _description,
        'Image': _image,
        'EventDate': _eventDate,
        'Link': _link,
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
        'Image': serializeParam(
          _image,
          ParamType.String,
        ),
        'EventDate': serializeParam(
          _eventDate,
          ParamType.DateTime,
        ),
        'Link': serializeParam(
          _link,
          ParamType.String,
        ),
      }.withoutNulls;

  static EventStruct fromSerializableMap(Map<String, dynamic> data) =>
      EventStruct(
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
        image: deserializeParam(
          data['Image'],
          ParamType.String,
          false,
        ),
        eventDate: deserializeParam(
          data['EventDate'],
          ParamType.DateTime,
          false,
        ),
        link: deserializeParam(
          data['Link'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EventStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EventStruct &&
        name == other.name &&
        description == other.description &&
        image == other.image &&
        eventDate == other.eventDate &&
        link == other.link;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, description, image, eventDate, link]);
}

EventStruct createEventStruct({
  String? name,
  String? description,
  String? image,
  DateTime? eventDate,
  String? link,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EventStruct(
      name: name,
      description: description,
      image: image,
      eventDate: eventDate,
      link: link,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EventStruct? updateEventStruct(
  EventStruct? event, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    event
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEventStructData(
  Map<String, dynamic> firestoreData,
  EventStruct? event,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (event == null) {
    return;
  }
  if (event.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && event.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final eventData = getEventFirestoreData(event, forFieldValue);
  final nestedData = eventData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = event.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEventFirestoreData(
  EventStruct? event, [
  bool forFieldValue = false,
]) {
  if (event == null) {
    return {};
  }
  final firestoreData = mapToFirestore(event.toMap());

  // Add any Firestore field values
  event.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEventListFirestoreData(
  List<EventStruct>? events,
) =>
    events?.map((e) => getEventFirestoreData(e, true)).toList() ?? [];
