import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:gestor_tarefas/src/enums/task_status_enum.dart';
import 'package:gestor_tarefas/src/models/task.dart';
import 'package:gestor_tarefas/src/widgets/g_button.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: const Text('Tarefas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GButton(
              onPressed: () {
                TextEditingController titleController = TextEditingController();
                TextEditingController descriptionController =
                    TextEditingController();
                TaskStatusEnum? selectedStatus;
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(ctx).pop();

                          await taskViewModel.addTask(
                            TaskModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              status: selectedStatus ?? TaskStatusEnum.pending,
                              minitask: [],
                            ),
                          );
                        },
                        child: const Text('Salvar'),
                      ),
                    ],
                    title: const Text('Adicionar Tarefa'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Título'),
                            controller: titleController,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Descrição'),
                            controller: descriptionController,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<TaskStatusEnum>(
                            decoration:
                                const InputDecoration(labelText: 'Status'),
                            items: TaskStatusEnum.values
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status.label),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              selectedStatus = value;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              label: 'Nova Tarefa',
              icon: Icons.add,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 1000,
              height: 4000,
              child: DragAndDropLists(
                listPadding: const EdgeInsets.all(2),
                axis: Axis.horizontal,
                children: TaskStatusEnum.values.map(
                  (status) {
                    return DragAndDropList(
                      header: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          status.label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      children: taskViewModel
                          .getTaskByStatus(status)
                          .map(
                            (e) => DragAndDropItem(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(e.title),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ).toList(),
                listWidth: 300,
                itemDraggingWidth: 250,
                listDraggingWidth: 300,
                onItemReorder: (oldItemIndex, oldListIndex, newItemIndex,
                    newListIndex) async {
                  final oldStatus = TaskStatusEnum.values[oldListIndex];
                  final newStatus = TaskStatusEnum.values[newListIndex];
                  final oldList = taskViewModel.getTaskByStatus(oldStatus);
                  final newList = taskViewModel.getTaskByStatus(newStatus);
                  final movedTask = oldList[oldItemIndex];

                  // Remove da lista antiga
                  oldList.removeAt(oldItemIndex);
                  // Adiciona na nova posição
                  if (oldStatus == newStatus) {
                    newList.insert(newItemIndex, movedTask);
                  } else {
                    final updatedTask = movedTask.copyWith(status: newStatus);
                    newList.insert(newItemIndex, updatedTask);
                    await taskViewModel.updateTaskStatus(movedTask, newStatus);
                  }
                  setState(() {});
                },
                onListReorder: (_, __) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
