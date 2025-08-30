enum TaskStatusEnum {
  pending('Pendente'),
  progress('Em andamento'),
  completed('Concluído');

  final String label;
  const TaskStatusEnum(this.label);

  static TaskStatusEnum fromString(String status) {
    return TaskStatusEnum.values.firstWhere((e) => e.name == status);
  }
}
