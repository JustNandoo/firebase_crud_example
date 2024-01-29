import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud_example/pages/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TodoController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController updatedTitle = TextEditingController();

  final uId = const Uuid();
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  RxList<TodoModel> todoList = RxList<TodoModel>();

  @override
  void onInit() {
    super.onInit();
    getTodo();
  }

  Future<void> addTodo() async {
    isLoading.value = true;
    String id = uId.v4();
    var newTodo = TodoModel(
      id: id,
      title: title.text,
    );
    await db.collection("todo").doc(id).set(newTodo.toJson());
    title.clear();
    getTodo();
    showSnackbar("Data added to Database");
    print("Note added to Database");
  }

  Future<void> getTodo() async {
    isLoading.value = true;
    todoList.clear();
    await db.collection("todo").get().then((allTodo) {
      for (var todo in allTodo.docs) {
        todoList.add(
          TodoModel.fromJson(
            todo.data(),
          ),
        );
      }
    });
    print("Get Todo");
    isLoading.value = false;
  }

  Future<void> deleteTodo(String id) async {
    isLoading.value = true;
    await db.collection("todo").doc(id).delete();
    print("Note Deleted");
    showSnackbar("Note Deleted");
    getTodo();
  }

  Future<void> updateTodo(TodoModel todo) async {
    isLoading.value = true;
    var updatedTodo = TodoModel(id: todo.id, title: updatedTitle.text);
    await db.collection("todo").doc(todo.id).set(updatedTodo.toJson());
    getTodo();
    Get.back();
    showSnackbar("Note Updated");
    print("Note Updated");
  }

  void showSnackbar(String message) {
    Get.snackbar(
      "Info",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 10,
      isDismissible: true,
    );
  }
}
