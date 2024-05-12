import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Models/filter_type.dart';
import 'package:todo/ProfileScreen.dart';
import 'package:todo/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  List<Todo> filtertodos = [];
  TextEditingController controller = TextEditingController();
  final String todoListKey = "todo_list";
  FilterType filterType = FilterType.all;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void updateFilteredTodoList() {
    setState(() {
      switch (filterType) {
        case FilterType.all:
          filtertodos = todos;
          break;
        case FilterType.done:
          filtertodos = todos.where((element) => element.done).toList();
          break;
        case FilterType.undone:
          filtertodos = todos.where((element) => !element.done).toList();
          break;
        default:
      }
    });
  }

  Future<void> _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var todosInStorage = prefs.getString(todoListKey);

    if (todosInStorage == null) {
      return;
    }

    var decodedTodos = jsonDecode(todosInStorage);
    List<Todo> t = [];
    for (var item in decodedTodos) {
      Todo todo = Todo.fromJson(item);
      t.add(todo);
    }
    setState(() {
      todos = t;
      updateFilteredTodoList();
    });
  }

  Future<void> _updateLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var maps = todos.map((e) => e.toJson()).toList();
    var json = jsonEncode(maps);
    await prefs.setString(todoListKey, json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              "Lio Todo",
              style: TextStyle(color: Colors.orange, fontSize: 24),
            ),
            const Spacer(),
            DropdownButton<FilterType>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              value: filterType,
              onChanged: (value) {
                if (value == filterType) {
                  return;
                }
                filterType = value!;
                updateFilteredTodoList();
              },
              items: FilterType.values
                  .map((e) => DropdownMenuItem<FilterType>(
                        value: e,
                        child: Text(e.title),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Yapılacak iş Ekle...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      var content =
                          'Yapılacak işin içeriği'; // Örnek bir todo içeriği
                      var creationDate = DateTime.now();

                      var todo = Todo(
                        content: content,
                        done:
                            false, // Varsayılan olarak 'yapılmadı' olarak ayarla
                        creationDate: creationDate,
                        lastUpdated:
                            creationDate, // İlk oluşturulduğunda güncelleme tarihi de oluşturulma tarihi ile aynı
                      );
                      todos.add(todo);
                      _updateLocalStorage();
                      controller.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                  child: const Text('Ekle', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            "Todo Listesi",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(95, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  itemCount: filtertodos.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.black87),
                  itemBuilder: (context, index) {
                    Todo todo = filtertodos[index];
                    return ListTile(
                      leading: Checkbox(
                        value: todo.done,
                        onChanged: (newValue) {
                          setState(() {
                            todo.done = newValue!;
                            todo.lastUpdated =
                                DateTime.now(); // Güncelleme tarihini ayarla
                            _updateLocalStorage();
                            updateFilteredTodoList();
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      title: Text(
                        todo.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Oluşturulma Tarihi: ${todo.creationDate.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          if (todo.creationDate != todo.lastUpdated)
                            Text(
                              'Son Güncelleme Tarihi: ${todo.lastUpdated.toString()}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            todos.remove(todo);
                            _updateLocalStorage();
                            updateFilteredTodoList();
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  todos.clear();
                  _updateLocalStorage();
                });
              },
              child: const Text(
                "Tümünü Sil",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }
}
