import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:todo_app/screens/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo CRUD App"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.todos.isEmpty
          ? const Center(
              child: Text("No Todos Found", style: TextStyle(fontSize: 18)),
            )
          : RefreshIndicator(
              onRefresh: provider.fetchTodos,
              child: ListView.builder(
                itemCount: provider.todos.length,
                itemBuilder: (context, index) {
                  final todo = provider.todos[index];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (_) {},
                      ),

                      title: Text(todo.title),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditTodoPage(todo: todo),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),

                          IconButton(
                            onPressed: () async {
                              final isDelete = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Todo"),
                                    content: const Text(
                                      "Are you sure you want to delete this todo?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (isDelete == true) {
                                provider.deleteTodo(todo.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Todo Deleted")),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTodoPage()),
          );
        },
        label: const Text("Add Todo"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
