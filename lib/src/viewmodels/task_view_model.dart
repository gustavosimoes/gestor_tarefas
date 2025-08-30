import 'package:flutter/material.dart';
import 'package:gestor_tarefas/src/datasources/firebase_datasource.dart';
import 'package:gestor_tarefas/src/models/task.dart';

class TaskViewModel extends ChangeNotifier {
  FirebaseDatasource firebaseDatasource = FirebaseDatasource();
  List<TaskModel> tasks = [];

  Future<void> fetchTasks() async {
    tasks = await firebaseDatasource.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await firebaseDatasource.saveTask(task);
    await fetchTasks();
  }
}
