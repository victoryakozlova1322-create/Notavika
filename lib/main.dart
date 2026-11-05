import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notavika',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TaskStatus { pending, done, failed }

class Task {
  String title;
  TaskStatus status;

  Task({required this.title, this.status = TaskStatus.pending});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(Task(title: _controller.text.trim()));
      _controller.clear();
    });
  }

  void _cycleStatus(int index) {
    setState(() {
      if (_tasks[index].status == TaskStatus.pending) {
        _tasks[index].status = TaskStatus.done;
      } else if (_tasks[index].status == TaskStatus.done) {
        _tasks[index].status = TaskStatus.failed;
      } else {
        _tasks[index].status = TaskStatus.pending;
      }
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Notavika Заметки'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Новая заметка',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Добавить'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('Список пуст. Добавьте первую задачу!'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        
                        Color color;
                        String statusText;
                        IconData icon;

                        switch (task.status) {
                          case TaskStatus.done:
                            color = Colors.green;
                            statusText = 'Сделано';
                            icon = Icons.check_circle;
                            break;
                          case TaskStatus.failed:
                            color = Colors.red;
                            statusText = 'Провалено';
                            icon = Icons.cancel;
                            break;
                          case TaskStatus.pending:
                          default:
                            color = Colors.orange;
                            statusText = 'В процессе';
                            icon = Icons.hourglass_bottom;
                            break;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.status != TaskStatus.pending
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ActionChip(
                                  avatar: Icon(icon, color: Colors.white, size: 16),
                                  label: Text(statusText),
                                  backgroundColor: color,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  onPressed: () => _cycleStatus(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                  onPressed: () => _deleteTask(index),
                                ),
                              ],
                            ),
                          ),
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
