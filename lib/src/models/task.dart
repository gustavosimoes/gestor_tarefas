class TaskModel {
  final String title;
  final String description;
  final String status;
  final List<MiniTask> minitask;

  TaskModel({
    required this.title,
    required this.description,
    required this.status,
    required this.minitask,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      minitask: (json['minitask'] as List<dynamic>)
          .map((e) => MiniTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'status': status,
        'minitask': minitask.map((e) => e.toJson()).toList(),
      };
}

class MiniTask {
  final String title;
  final bool doTask;

  MiniTask({
    required this.title,
    required this.doTask,
  });

  factory MiniTask.fromJson(Map<String, dynamic> json) {
    return MiniTask(
      title: json['title'] as String,
      doTask: json['do'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'do': doTask,
      };
}
