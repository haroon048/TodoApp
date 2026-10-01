import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/models/todo_model.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/todos";

  // ===================== GET =====================

  Future<List<TodoModel>> getTodos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => TodoModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load todos");
    }
  }

  // ===================== POST =====================

  Future<TodoModel> addTodo(TodoModel todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add todo");
    }
  }

  // ===================== PUT =====================

  Future<TodoModel> updateTodo(TodoModel todo) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${todo.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update todo");
    }
  }

  // ===================== DELETE =====================

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete todo");
    }
  }
}
