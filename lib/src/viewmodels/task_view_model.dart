import 'package:flutter/material.dart';
import 'package:gestor_tarefas/src/datasources/firebase_datasource.dart';
import 'package:gestor_tarefas/src/enums/task_status_enum.dart';
import 'package:gestor_tarefas/src/models/task.dart';

class TaskViewModel extends ChangeNotifier {
  Future<void> updateTaskStatus(TaskModel task, TaskStatusEnum status) async {
    await firebaseDatasource.updateTaskStatus(task.docId!, status.name);
    await fetchTasks();
  }

  FirebaseDatasource firebaseDatasource = FirebaseDatasource();
  List<TaskModel> tasks = [];

  List<TaskModel> getTaskByStatus(TaskStatusEnum status) =>
      tasks.where((task) => task.status == status).toList();

  Future<void> fetchTasks() async {
    tasks = await firebaseDatasource.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await firebaseDatasource.saveTask(task);
    await fetchTasks();
  }
}
