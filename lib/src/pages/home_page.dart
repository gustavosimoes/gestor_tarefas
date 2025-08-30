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
    final tasks = taskViewModel.tasks;
    return Scaffold(
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
                          await taskViewModel.addTask(
                            TaskModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              status: selectedStatus ?? TaskStatusEnum.pending,
                              minitask: [],
                            ),
                          );

                          Navigator.of(ctx).pop();
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
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task.title),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
