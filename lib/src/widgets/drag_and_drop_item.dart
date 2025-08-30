import 'package:flutter/material.dart';
import 'package:gestor_tarefas/src/models/task.dart';

class DragAndDropItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final void Function(TaskModel)? onAccept;

  const DragAndDropItem({
    super.key,
    required this.task,
    this.onTap,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<TaskModel>(
      data: task,
      feedback: Material(
        child: Card(
          color: Colors.grey.shade200,
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Card(
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
        ),
      ),
    );
  }
}
