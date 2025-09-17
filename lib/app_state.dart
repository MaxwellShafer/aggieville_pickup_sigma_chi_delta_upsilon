import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _tasks = prefs
              .getStringList('ff_tasks')
              ?.map((x) {
                try {
                  return TaskStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _tasks;
    });
    _safeInit(() {
      _events = prefs
              .getStringList('ff_events')
              ?.map((x) {
                try {
                  return EventStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _events;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<TaskStruct> _tasks = [];
  List<TaskStruct> get tasks => _tasks;
  set tasks(List<TaskStruct> value) {
    _tasks = value;
    prefs.setStringList('ff_tasks', value.map((x) => x.serialize()).toList());
  }

  void addToTasks(TaskStruct value) {
    tasks.add(value);
    prefs.setStringList('ff_tasks', _tasks.map((x) => x.serialize()).toList());
  }

  void removeFromTasks(TaskStruct value) {
    tasks.remove(value);
    prefs.setStringList('ff_tasks', _tasks.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromTasks(int index) {
    tasks.removeAt(index);
    prefs.setStringList('ff_tasks', _tasks.map((x) => x.serialize()).toList());
  }

  void updateTasksAtIndex(
    int index,
    TaskStruct Function(TaskStruct) updateFn,
  ) {
    tasks[index] = updateFn(_tasks[index]);
    prefs.setStringList('ff_tasks', _tasks.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInTasks(int index, TaskStruct value) {
    tasks.insert(index, value);
    prefs.setStringList('ff_tasks', _tasks.map((x) => x.serialize()).toList());
  }

  List<EventStruct> _events = [];
  List<EventStruct> get events => _events;
  set events(List<EventStruct> value) {
    _events = value;
    prefs.setStringList('ff_events', value.map((x) => x.serialize()).toList());
  }

  void addToEvents(EventStruct value) {
    events.add(value);
    prefs.setStringList(
        'ff_events', _events.map((x) => x.serialize()).toList());
  }

  void removeFromEvents(EventStruct value) {
    events.remove(value);
    prefs.setStringList(
        'ff_events', _events.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromEvents(int index) {
    events.removeAt(index);
    prefs.setStringList(
        'ff_events', _events.map((x) => x.serialize()).toList());
  }

  void updateEventsAtIndex(
    int index,
    EventStruct Function(EventStruct) updateFn,
  ) {
    events[index] = updateFn(_events[index]);
    prefs.setStringList(
        'ff_events', _events.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInEvents(int index, EventStruct value) {
    events.insert(index, value);
    prefs.setStringList(
        'ff_events', _events.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
