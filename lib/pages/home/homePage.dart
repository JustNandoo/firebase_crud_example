import 'dart:ffi';

import 'package:firebase_crud_example/pages/home/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoController todoController = Get.put(TodoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 124, 95, 0),
      ),
      body: Obx(() => todoController.isLoading.value ?
      Center(
        child: CircularProgressIndicator(),
      ) : 
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: todoController.title,
                    decoration: InputDecoration(
                      hintText: "Enter your note",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    todoController.addTodo();
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 17, 17, 17),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "ALL NOTES",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView(
                  children: todoController.todoList
                      .map(
                        (e) => Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            tileColor: Colors.white,
                            onTap: () {},
                            title: Text(
                              e.title!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    todoController.deleteTodo(e.id!);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    todoController.updatedTitle.text = e.title!;
                                    Get.defaultDialog(
                                      title: "Edit Note",
                                      content: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Container(
                                            height: 100,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: todoController
                                                        .updatedTitle,
                                                    decoration: InputDecoration(
                                                      hintText: "Edit note",
                                                      fillColor:
                                                          Colors.grey[200],
                                                      filled: true,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    todoController
                                                        .updateTodo(e);
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 7, 7, 7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),) 
    );
  }
}