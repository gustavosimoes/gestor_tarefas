import 'package:flutter/material.dart';
import 'package:gestor_tarefas/src/datasources/firebase_datasource.dart';
import 'package:gestor_tarefas/src/models/task.dart';

class TaskViewModel extends ChangeNotifier {
  List<TaskModel> tasks = [];

  Future<void> fetchTasks() async {
    tasks = await FirebaseDatasource().getData();
    notifyListeners();
  }
}
