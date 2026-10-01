import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/api_service.dart';

class TodoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //================ GET TODOS ================

  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _apiService.getTodos();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  //================ ADD TODO ================

  Future<void> addTodo(TodoModel todo) async {
    try {
      final newTodo = await _apiService.addTodo(todo);
      _todos.insert(0, newTodo);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //================ UPDATE TODO ================

  Future<void> updateTodo(TodoModel todo) async {
    try {
      final updatedTodo = await _apiService.updateTodo(todo);

      final index = _todos.indexWhere((element) => element.id == todo.id);

      if (index != -1) {
        _todos[index] = updatedTodo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //================ DELETE TODO ================

  Future<void> deleteTodo(int id) async {
    try {
      await _apiService.deleteTodo(id);

      _todos.removeWhere((element) => element.id == id);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
