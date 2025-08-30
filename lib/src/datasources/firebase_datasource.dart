import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestor_tarefas/src/models/task.dart';

class FirebaseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getData(String collection) async {
    final snapshot = await _firestore.collection(collection).get();
    final data =
        snapshot.docs.map((doc) => {'docId': doc.id, ...doc.data()}).toList();
    return data;
  }

  Future<List<TaskModel>> getTasks() async {
    final rawData = await _getData('task');
    final tasks = rawData.map((data) => TaskModel.fromJson(data)).toList();
    return tasks;
  }

  Future<void> _saveData(String collection, Map<String, dynamic> json) async {
    await _firestore.collection(collection).add(json);
  }

  Future<void> saveTask(TaskModel task) async {
    await _saveData('task', task.toJson());
  }

  Future<void> _updateData({
    required String collection,
    required String docId,
    required Map<String, dynamic> json,
  }) async {
    await _firestore.collection(collection).doc(docId).update(json);
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _updateData(
      collection: 'task',
      docId: taskId,
      json: {'status': newStatus},
    );
  }
}
